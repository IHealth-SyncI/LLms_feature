import psycopg2
from psycopg2.extras import RealDictCursor
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
import os
from psycopg2.extras import RealDictCursor
import datetime

import torch
from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline
from langchain.llms.huggingface_pipeline import HuggingFacePipeline

# --- Configuration ---
DB_URI = os.getenv(
    "DB_URI", "postgresql://healthsync:healthsyncpass@localhost:5432/healthsync_db"
)
# OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "sk-...")


# --- Database Connection ---
def get_db_connection():
    try:
        conn = psycopg2.connect(DB_URI, cursor_factory=RealDictCursor)
        return conn
    except Exception as e:
        print(f"Database connection error: {e}")
        return None


# --- Data Fetching Functions ---
def fetch_patient_demographics(conn, patient_id):
    """
    Fetch patient name, age, gender, and category from AspNetUsers and Patients tables.
    """
    query = """
        SELECT u."Id", u."UserName", u."DOB", u."Gender", p."Category"
        FROM "AspNetUsers" u
        JOIN "Patients" p ON u."Id" = p."Patient_ID"
        WHERE p."Patient_ID" = %s
    """
    with conn.cursor() as cur:
        cur.execute(query, (patient_id,))
        result = cur.fetchone()
        if not result:
            return None
        # Calculate age
        dob = result["DOB"]
        age = None
        if dob:
            today = datetime.date.today()
            age = (
                today.year
                - dob.year
                - ((today.month, today.day) < (dob.month, dob.day))
            )
        return {
            "id": result["Id"],
            "name": result["UserName"],
            "age": age,
            "gender": result["Gender"],
            "category": result["Category"],
        }


# def fetch_patient_demographics(conn, patient_id):
#     """
#     Fetch patient name, age, gender, and category from AspNetUsers and Patients tables.
#     """
#     query = """
#         SELECT u."Id", u."UserName", u."DOB", u."Gender", p."Category"
#         FROM "AspNetUsers" u
#         JOIN "Patients" p ON u."Id" = p."Patient_ID"
#         WHERE p."Patient_ID" = %s
#     """
#     with conn.cursor(cursor_factory=RealDictCursor) as cur:
#         cur.execute(query, (patient_id,))
#         result = cur.fetchone()
#         if not result:
#             return None
#
#         # Calculate age
#         dob = result.get("DOB")
#         age = None
#         if dob:
#             today = datetime.date.today()
#             age = (
#                 today.year
#                 - dob.year
#                 - ((today.month, today.day) < (dob.month, dob.day))
#             )
#
#         return {
#             "id": result["Id"],
#             "name": result["UserName"],
#             "age": age,
#             "gender": result["Gender"],
#             "category": result["Category"],
#         }


def fetch_medical_history(conn, patient_id):
    """
    Fetch medical history summary from MedicalHistories and MedicalRecords tables.
    """
    # Get MedicalHistory_ID for the patient
    query_history = """
        SELECT "MedicalHistory_ID" FROM "MedicalHistories"
        WHERE "Patient_ID1" = %s
    """
    with conn.cursor() as cur:
        cur.execute(query_history, (patient_id,))
        row = cur.fetchone()
        if not row:
            return "No medical history found."
        history_id = row["MedicalHistory_ID"]
        # Get all medical records for this history
        query_records = """
            SELECT "Date", "Type", "Category", "Details"
            FROM "MedicalRecords"
            WHERE "MedicalHistory_ID1" = %s
            ORDER BY "Date" DESC
        """
        cur.execute(query_records, (history_id,))
        records = cur.fetchall()
        if not records:
            return "No medical records found."
        # Summarize
        summary = []
        for rec in records:
            summary.append(
                f"{rec['Date'].strftime('%Y-%m-%d')}: {rec['Type']} - {rec['Category']} - {rec['Details']}"
            )
        return "\n".join(summary)


def fetch_recent_visits(conn, patient_id, limit=5):
    """
    Fetch recent visits from MedicalRecords where Type='Visit'.
    """
    query = """
        SELECT "Date", "Diagnosis", "Details", "Treatment"
        FROM "MedicalRecords"
        WHERE "MedicalHistory_ID1" = (
            SELECT "MedicalHistory_ID" FROM "MedicalHistories" WHERE "Patient_ID1" = %s
        ) AND "Type" = 'Visit'
        ORDER BY "Date" DESC
        LIMIT %s
    """
    with conn.cursor() as cur:
        cur.execute(query, (patient_id, limit))
        visits = cur.fetchall()
        if not visits:
            return "No recent visits found."
        summary = []
        for v in visits:
            date = v["Date"].strftime("%Y-%m-%d")
            diagnosis = v.get("Diagnosis", "")
            treatment = v.get("Treatment", "")
            details = v.get("Details", "")
            summary.append(
                f"{date}: Diagnosis: {diagnosis}, Treatment: {treatment}, Details: {details}"
            )
        return "\n".join(summary)


def fetch_lab_results(conn, patient_id, limit=10):
    """
    Fetch lab results from MedicalRecords where Type='Lab'.
    """
    query = """
        SELECT "Date", "Details", "Category"
        FROM "MedicalRecords"
        WHERE "MedicalHistory_ID1" = (
            SELECT "MedicalHistory_ID" FROM "MedicalHistories" WHERE "Patient_ID1" = %s
        ) AND "Type" = 'Lab'
        ORDER BY "Date" DESC
        LIMIT %s
    """
    with conn.cursor() as cur:
        cur.execute(query, (patient_id, limit))
        labs = cur.fetchall()
        if not labs:
            return "No lab results found."
        summary = []
        for l in labs:
            date = l["Date"].strftime("%Y-%m-%d")
            category = l.get("Category", "")
            details = l.get("Details", "")
            summary.append(f"{date}: {category} - {details}")
        return "\n".join(summary)


# --- LLM Prompt Template ---
def generate_llm_prompt(
    patient_name, age, gender, medical_history, visits_summary, lab_results
):
    """
    Generate a structured prompt for the LLM to create a professional medical report.
    """
    template = (
        "Generate a professional medical report for {patient_name} ({age}, {gender}) based on the following data:\n\n"
        "**Medical History**:\n"
        "{medical_history}\n\n"
        "**Recent Visits**:\n"
        "{visits_summary}\n\n"
        "**Lab Results**:\n"
        "{lab_results}\n\n"
        "**Summary & Recommendations**:\n"
        "[LLM should generate this section]\n"
    )
    prompt = template.format(
        patient_name=patient_name,
        age=age,
        gender=gender,
        medical_history=medical_history,
        visits_summary=visits_summary,
        lab_results=lab_results,
    )
    return prompt


# --- PDF Generation ---
def generate_pdf_report(patient_id, report_text):
    """
    Generate a PDF report using reportlab and save it as patient_{patient_id}_report.pdf.
    """
    filename = f"patient_{patient_id}_report.pdf"
    c = canvas.Canvas(filename, pagesize=letter)
    width, height = letter
    margin = 50
    y = height - margin

    # Title
    c.setFont("Helvetica-Bold", 18)
    c.drawString(margin, y, "Patient Medical Report")
    y -= 30

    # Date
    c.setFont("Helvetica", 10)
    c.drawString(
        margin, y, f"Generated on: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M')}"
    )
    y -= 20

    # Report Body
    c.setFont("Helvetica", 12)

    # Validate report_text
    if not report_text:
        report_text = "No report content available."

    # Split text into lines and handle empty lines
    lines = report_text.split("\n") if report_text else ["No content available"]

    for line in lines:
        if y < margin + 20:
            c.showPage()
            y = height - margin
            c.setFont("Helvetica", 12)

        # Handle empty lines
        if not line.strip():
            y -= 8  # Smaller spacing for empty lines
            continue

        c.drawString(margin, y, line)
        y -= 16

    c.save()
    return filename


# --- Main Orchestration Function ---
def generate_patient_report(patient_id):
    """
    Orchestrate the workflow: fetch data, generate report, and save as PDF.
    """
    conn = get_db_connection()
    if not conn:
        print("Failed to connect to the database.")
        return
    try:
        # Fetch data
        demographics = fetch_patient_demographics(conn, patient_id)
        if not demographics:
            print(f"No patient found with ID {patient_id}.")
            return
        medical_history = fetch_medical_history(conn, patient_id)
        visits_summary = fetch_recent_visits(conn, patient_id)
        lab_results = fetch_lab_results(conn, patient_id)

        # Prepare prompt
        prompt = generate_llm_prompt(
            demographics["name"],
            demographics["age"],
            demographics["gender"],
            medical_history,
            visits_summary,
            lab_results,
        )

        llm = HuggingFacePipeline.from_model_id(
            model_id="foundationmodels/MIMIC-medical-report",
            task="text-generation"
        )
        # Generate report text using LLM
        # llm = OpenAI(openai_api_key=OPENAI_API_KEY, temperature=0.2)
        report_text = llm(prompt)

        # Generate PDF
        pdf_filename = generate_pdf_report(patient_id, report_text)
        print(f"Report generated: {pdf_filename}")
    except Exception as e:
        print(f"Error generating report: {e}")
        import traceback

        traceback.print_exc()
    finally:
        conn.close()


# def generate_patient_report(patient_id):
#     """
#     Orchestrate the workflow: fetch data, generate report, and save as PDF.
#     Uses local DeepSeek-R1 7B model instead of OpenAI.
#     """
#     conn = get_db_connection()
#     if not conn:
#         print("Failed to connect to the database.")
#         return
#     try:
#         # Fetch data
#         demographics = fetch_patient_demographics(conn, patient_id)
#         if not demographics:
#             print(f"No patient found with ID {patient_id}.")
#             return
#         medical_history = fetch_medical_history(conn, patient_id)
#         visits_summary = fetch_recent_visits(conn, patient_id)
#         lab_results = fetch_lab_results(conn, patient_id)
#
#
#
#         # Prepare prompt
#         prompt = generate_llm_prompt(
#             demographics["name"],
#             demographics["age"],
#             demographics["gender"],
#             medical_history,
#             visits_summary,
#             lab_results,
#         )
#
#         # Load local DeepSeek model (cache after first load)
#         model_path = "./deepseek-r1-7b"  # Update with your actual path
#         tokenizer = AutoTokenizer.from_pretrained(model_path)
#         model = AutoModelForCausalLM.from_pretrained(
#             model_path,
#             device_map="auto",
#             torch_dtype=torch.bfloat16,  # Better precision than float16
#             low_cpu_mem_usage=True
#         )
#
#         # Create text generation pipeline
#         # pipe = pipeline(
#         #     "text-generation",
#         #     model=model,
#         #     tokenizer=tokenizer,
#         #     max_new_tokens=1024,  # Control response length
#         #     temperature=0.3,  # Slightly higher for creativity
#         #     do_sample=True,
#         #     top_p=0.9,
#         #     repetition_penalty=1.05  # Reduce repetition
#         # )
#
#         hf = HuggingFacePipeline.from_model_id(
#             model_id="deepseek-r1-7b", task="text-generation",
#             pipeline_kwargs={"max_new_tokens": 200, "pad_token_id": 50256},
#         )
#
#         # Generate report text
#         # llm = HuggingFacePipeline(pipeline=pipe)
#         full_response = llm(prompt)
#
#         # Extract only the assistant's response
#         report_text = full_response.split("Assistant:")[-1].strip()
#
#         # Generate PDF
#         pdf_filename = generate_pdf_report(patient_id, report_text)
#         print(f"Report generated: {pdf_filename}")
#     except Exception as e:
#         print(f"Error generating report: {e}")
#         import traceback
#         traceback.print_exc()
#     finally:
#         conn.close()

if __name__ == "__main__":
    # Example usage
    pid = input("Enter patient ID: ")
    generate_patient_report(pid)
