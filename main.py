from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse
from patient_report_generator import generate_patient_report
from pydantic import BaseModel
from typing import List, Optional
from llm_utils import get_llm_instance
import json
import re
import os

app = FastAPI()


class SymptomRequest(BaseModel):
    symptoms: str  # Natural language description of symptoms
    age: Optional[int] = None
    gender: Optional[str] = None
    severity: Optional[str] = "moderate"  # mild, moderate, severe
    duration: Optional[str] = None  # e.g., "2 days", "1 week"


class DoctorRecommendation(BaseModel):
    specialty: str
    doctor_type: str
    description: str
    urgency_level: str  # low, medium, high, emergency
    recommended_action: str
    confidence_score: float


class DoctorRecommendationResponse(BaseModel):
    patient_symptoms: str
    recommendations: List[DoctorRecommendation]
    general_advice: str
    emergency_warning: Optional[str] = None


def generate_doctor_recommendation_prompt(
    symptoms: str,
    age: Optional[int],
    gender: Optional[str],
    severity: str,
    duration: Optional[str],
) -> str:
    """
    Generate a structured prompt for the LLM to analyze symptoms and recommend doctors.
    """
    patient_info = f"Age: {age if age else 'Not specified'}, Gender: {gender if gender else 'Not specified'}"

    prompt = f"""
You are a medical triage AI assistant. Analyze the following patient symptoms and provide structured doctor recommendations.

Patient Information:
{patient_info}
Severity: {severity}
Duration: {duration if duration else 'Not specified'}

Patient Symptoms:
{symptoms}

Please analyze these symptoms and provide recommendations in the following JSON format:

{{
  "emergency_warning": "EMERGENCY: [warning message if life-threatening symptoms detected, otherwise null]",
  "recommendations": [
    {{
      "specialty": "[medical specialty]",
      "doctor_type": "[specific type of doctor]",
      "description": "[brief description of what this specialist does]",
      "urgency_level": "[low/medium/high/emergency]",
      "recommended_action": "[specific action patient should take]",
      "confidence_score": [0.0-1.0]
    }}
  ],
  "general_advice": "[general advice for the patient based on symptoms and severity]"
}}

Important Guidelines:
1. If you detect life-threatening symptoms (chest pain, difficulty breathing, severe bleeding, unconsciousness, stroke symptoms, heart attack, anaphylaxis), set urgency_level to "emergency" and provide an emergency warning.
2. Consider the patient's age, gender, severity, and duration when making recommendations.
3. Provide confidence scores based on how clearly the symptoms match a particular specialty.
4. Include multiple recommendations if symptoms suggest multiple specialties.
5. If symptoms are vague or general, recommend a primary care physician.
6. Be specific about the type of doctor and why they should see them.

Respond only with valid JSON. Do not include any additional text or explanations outside the JSON structure.
"""
    return prompt


def parse_llm_response(response_text: str) -> dict:
    """
    Parse the LLM response and extract JSON content.
    """
    # Clean the response to extract JSON
    response_text = response_text.strip()

    # Try to find JSON in the response
    json_match = re.search(r"\{.*\}", response_text, re.DOTALL)
    if json_match:
        json_str = json_match.group()
        try:
            return json.loads(json_str)
        except json.JSONDecodeError:
            pass

    # If no valid JSON found, return default response
    return {
        "emergency_warning": None,
        "recommendations": [
            {
                "specialty": "Primary Care",
                "doctor_type": "Primary Care Physician",
                "description": "General practitioner who can assess symptoms and refer to specialists if needed",
                "urgency_level": "low",
                "recommended_action": "Schedule appointment with primary care physician",
                "confidence_score": 0.70,
            }
        ],
        "general_advice": "Please consult with a healthcare provider for proper diagnosis and treatment.",
    }


@app.get("/generate_report/{patient_id}")
def generate_report(patient_id: str):
    pdf_filename = f"patient_{patient_id}_report.pdf"
    # Remove old file if exists
    if os.path.exists(pdf_filename):
        os.remove(pdf_filename)
    # Generate the report
    generate_patient_report(patient_id)
    if not os.path.exists(pdf_filename):
        raise HTTPException(status_code=404, detail="Report could not be generated.")
    return FileResponse(
        pdf_filename, media_type="application/pdf", filename=pdf_filename
    )


@app.post("/recommend_doctor", response_model=DoctorRecommendationResponse)
def recommend_doctor(request: SymptomRequest):
    """
    Analyze patient symptoms from natural language description using LLM and recommend appropriate medical specialists.
    """

    try:
        # Generate prompt for LLM
        prompt = generate_doctor_recommendation_prompt(
            request.symptoms,
            request.age,
            request.gender,
            request.severity,
            request.duration,
        )

        # Get LLM instance
        llm = get_llm_instance()

        # Get LLM response
        response_text = llm.invoke(prompt)

        # Parse the response
        parsed_response = parse_llm_response(response_text)

        # Convert to Pydantic models
        recommendations = []
        for rec in parsed_response.get("recommendations", []):
            recommendations.append(
                DoctorRecommendation(
                    specialty=rec.get("specialty", "Primary Care"),
                    doctor_type=rec.get("doctor_type", "Primary Care Physician"),
                    description=rec.get("description", "General practitioner"),
                    urgency_level=rec.get("urgency_level", "low"),
                    recommended_action=rec.get(
                        "recommended_action", "Schedule appointment"
                    ),
                    confidence_score=rec.get("confidence_score", 0.70),
                )
            )

        return DoctorRecommendationResponse(
            patient_symptoms=request.symptoms,
            recommendations=recommendations,
            general_advice=parsed_response.get(
                "general_advice", "Please consult with a healthcare provider."
            ),
            emergency_warning=parsed_response.get("emergency_warning"),
        )

    except Exception as e:
        # Fallback to basic recommendation if LLM fails
        print(f"LLM error: {e}")
        return DoctorRecommendationResponse(
            patient_symptoms=request.symptoms,
            recommendations=[
                DoctorRecommendation(
                    specialty="Primary Care",
                    doctor_type="Primary Care Physician",
                    description="General practitioner who can assess symptoms and refer to specialists if needed",
                    urgency_level="low",
                    recommended_action="Schedule appointment with primary care physician",
                    confidence_score=0.10,
                )
            ],
            general_advice="Please consult with a healthcare provider for proper diagnosis and treatment.",
            emergency_warning=None,
        )
