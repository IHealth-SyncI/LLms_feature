from langchain_ollama.llms import OllamaLLM
import psycopg2
from psycopg2.extras import RealDictCursor
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
import os
import re
from psycopg2.extras import RealDictCursor
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.lib.units import inch
import datetime
import markdown
from bs4 import BeautifulSoup
from llm_utils import get_llm_instance

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
# --- LLM Prompt Template ---
def generate_llm_prompt(
    patient_name, age, gender, medical_history, visits_summary, lab_results
):
    """
    Generate a structured prompt for the LLM to create a professional medical report.
    """
    template = (
        "Generate a professional medical report in Markdown format for {patient_name} ({age}, {gender}) "
        "with the following structure:\n\n"
        "# Medical Report\n\n"
        "## Patient Information\n"
        "- **Name**: {patient_name}\n"
        "- **Age**: {age}\n"
        "- **Gender**: {gender}\n\n"
        "## Medical History\n"
        "{medical_history}\n\n"
        "## Recent Visits Summary\n"
        "{visits_summary}\n\n"
        "## Lab Results\n"
        "{lab_results}\n\n"
        "## Assessment & Recommendations\n"
        "[LLM should generate this section with detailed analysis]\n\n"
        "## Treatment Plan\n"
        "[LLM should generate this section with specific recommendations]"
    )
    return template.format(
        patient_name=patient_name,
        age=age,
        gender=gender,
        medical_history=medical_history,
        visits_summary=visits_summary,
        lab_results=lab_results,
    )


# --- PDF Generation with Markdown ---
def generate_pdf_report(patient_id, md_report_text):
    """
    Generate a clean PDF report from Markdown content, excluding any LLM thinking/analysis text.
    """
    filename = f"patient_{patient_id}_report.pdf"

    # Convert Markdown to HTML
    html = markdown.markdown(md_report_text)

    # Parse HTML to extract structured content
    soup = BeautifulSoup(html, "html.parser")

    # Create PDF document
    doc = SimpleDocTemplate(filename, pagesize=letter)
    styles = getSampleStyleSheet()

    # Modify existing styles
    styles["Title"].fontSize = 18
    styles["Title"].spaceAfter = 24
    styles["Heading1"].fontSize = 16
    styles["Heading1"].spaceAfter = 12
    styles["Heading2"].fontSize = 14
    styles["Heading2"].spaceAfter = 10

    story = []

    # Add title and metadata
    story.append(Paragraph("MEDICAL REPORT", styles["Title"]))
    story.append(
        Paragraph(
            f"Report Date: {datetime.datetime.now().strftime('%Y-%m-%d')}",
            styles["Normal"],
        )
    )
    story.append(Spacer(1, 0.5 * inch))

    # Process only the relevant sections
    current_section = None
    for element in soup.find_all(recursive=False):
        if element.name in ["h1", "h2"]:
            current_section = element.get_text().lower()
            if current_section not in [
                "assessment & recommendations",
                "treatment plan",
            ]:
                story.append(
                    Paragraph(
                        element.get_text(),
                        styles[f'Heading{1 if element.name == "h1" else 2}'],
                    )
                )
        elif element.name in ["p", "ul"] and current_section not in [
            "assessment & recommendations",
            "treatment plan",
        ]:
            if element.name == "ul":
                for li in element.find_all("li"):
                    story.append(Paragraph(f"• {li.get_text()}", styles["Normal"]))
            else:
                story.append(Paragraph(element.get_text(), styles["Normal"]))
            story.append(Spacer(1, 0.2 * inch))

    doc.build(story)
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

        # === Use Ollama model ===
        llm = get_llm_instance()

        # Generate report text using LLM
        report_text = llm.invoke(prompt)
        cleaned_report = re.sub(r"<think>.*?</think>", "", report_text, flags=re.DOTALL)
        # cleaned_report = re.sub(r"```markdown", "", cleaned_report, flags=re.DOTALL)
        # cleaned_report = re.sub(r"```", "", cleaned_report, flags=re.DOTALL)

        print(cleaned_report)
        # Generate PDF
        pdf_filename = generate_pdf_report(patient_id, cleaned_report)
        print(f"Report generated: {pdf_filename}")

    except Exception as e:
        print(f"Error generating report: {e}")
        import traceback

        traceback.print_exc()

    finally:
        conn.close()


if __name__ == "__main__":
    # Example usage
    # pid = input("Enter patient ID: ")
    print("Patient 1 Report:")
    generate_patient_report("patient1")
