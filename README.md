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
