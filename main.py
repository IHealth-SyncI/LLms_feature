from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse
from patient_report_generator import generate_patient_report
import os

app = FastAPI()


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
