# Patient Report Generator System

## Overview

This project generates professional medical reports as PDFs for patients, using data from a PostgreSQL database and an LLM (OpenAI GPT) via LangChain. The system is accessible via a FastAPI endpoint.

## Setup Instructions

### 1. Start the PostgreSQL Database (Docker)

```
docker-compose up -d
```

This will start a PostgreSQL instance with the schema and dummy data defined in `db-init/01_init_schema.sql`.

- DB user: `healthsync`
- DB password: `healthsyncpass`
- DB name: `healthsync_db`
- Port: `5432`

### 2. Install Python Dependencies

It is recommended to use a virtual environment:

```
pip install -r requirements.txt
```

### 3. Set Environment Variables

Set your OpenAI API key (required for report generation):

```
export OPENAI_API_KEY=sk-...
export DB_URI=postgresql://healthsync:healthsyncpass@localhost:5432/healthsync_db
```

On Windows, use `set` instead of `export`.

### 4. Run the FastAPI App

```
uvicorn main:app --reload
```

### 5. Generate a Patient Report

Open your browser or use curl/Postman:

```
GET http://localhost:8000/generate_report/patient1
```

This will return a PDF file for the dummy patient.

## Customization

- Add more dummy data to `db-init/01_init_schema.sql` as needed.
- Adjust the prompt or PDF formatting in `patient_report_generator.py`.

## Notes

- The LLM (OpenAI) is required for generating the summary and recommendations section.
- The system is for demo/development purposes. For production, add authentication and security as needed.


**Professional Medical Report for John Doe**
---
**Demographics:**
- Name: John Doe
- Age: 45 years
- Gender: Male
---
**Medical History Overview:**
John Doe has a history of significant cardiovascular concerns, primarily related to coronary artery disease 1. **Coronary Artery Disease:**
 - **2022-02-15:** Cardiac catheterization revealed 50% mid-LAD stenosis and 30% RCA stenosis with a - **2020-04-05:** Exercise stress echocardiogram showed mild anterior wall hypokinesis during stress b2. **Hypertension:**
 - **2021-08-10:** Overcontrolled hypertension with BP 118/74 mmHg, adhering to medication.
 - **2020-09-15:** Uncontrolled hypertension managed with Lisinopril and home BP monitoring.
3. **Other Concerns:**
 - High triglycerides (175 mg/dL) noted in 2020 lab results, despite normal liver enzymes.
 - Intermittent substernal chest pressure during exercise, possibly related to CAD or LV dysfunction.
---
**Recent Visits and Management:**
- **2024-05-01:** Routine checkup with no significant issues noted.
- **2021-08-10:** Overcontrolled hypertension managed with Losartan.
- **2020-09-15:** Uncontrolled hypertension treated with Lisinopril and home BP monitoring.
- **2020-04-05:** Stable angina managed with isosorbide mononitrate, leading to cardiac rehab referral.
---
**Lab Results:**
- **2020-06-22:** Elevated triglycerides (175 mg/dL), normal AST and ALT.
- **2024-05-10:** Normal hemoglobin (14) and WBC (6).
---
**Summary of Concerns:**
John Doe presents with significant CAD involving both LAD and RCA, evidenced by catheterization finding---
**Recommendations:**
1. **Lifestyle Modifications:**
 - Implement a diet low in saturated fats and trans fats.
 - Increase physical activity, particularly cardiovascular exercise (e.g., brisk walking).
2. **Medications:**
 - Consider lowering triglycerides with statins or Ezetimibe if levels remain elevated.
3. **Monitoring:**
 - Regular follow-ups for CAD progression and hypertension control.
4. **Further Testing:**
 - Consider stress testing to assess LV function.
 - Evaluate for metabolic causes of CAD, such as dyslipidemia or diabetes.
---
This report highlights John Doe's significant cardiovascular risks and the need for comprehensive manage