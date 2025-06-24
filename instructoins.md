System: Patient Report Generator (SQL + LangChain)
Goal:

Fetch structured patient data from PostgreSQL.

Generate a well-formatted medical report.

Convert the report into a PDF.

Step 1: Set Up PostgreSQL Connection
Install Required Libraries

psycopg2 (PostgreSQL adapter for Python)

langchain (for LLM integration)

openai (if using GPT-4/GPT-3.5)

reportlab (for PDF generation)

Configure Database Access

Provide the AI assistant with:

Database URI (e.g., postgresql://user:password@localhost:5432/medical_db)

Table names (patients, visits, lab_results)

Sample schema (if needed for context)

Step 2: Create SQL Query Functions
Write a function to fetch patient demographics

Query: SELECT name, age, gender, medical_history FROM patients WHERE patient_id = ?

Write a function to fetch recent visits

Query: SELECT visit_date, diagnosis, treatment FROM visits WHERE patient_id = ? ORDER BY visit_date DESC LIMIT 5

Write a function to fetch lab results

Query: SELECT test_name, result, reference_range FROM lab_results WHERE patient_id = ? ORDER BY test_date DESC LIMIT 10

Step 3: Design the LLM Prompt
Define a structured prompt template (instruct the AI to generate this):

text
"Generate a professional medical report for {patient_name} ({age}, {gender}) based on the following data:  

**Medical History**:  
{medical_history}  

**Recent Visits**:  
{visits_summary}  

**Lab Results**:  
{lab_results}  

**Summary & Recommendations**:  
[LLM should generate this section]  
"  
Ask the AI to:

Format the data into clear sections.

Summarize key findings.

Suggest follow-ups if abnormalities exist.

Step 4: Generate the PDF
Use reportlab to create a PDF

Instructions for the AI:

Initialize a PDF document.

Add headings (Patient Report, Lab Results, etc.).

Insert the LLM-generated text in a readable format.

Save to a file (e.g., patient_{id}_report.pdf).

Step 5: Orchestrate the Workflow
Ask the AI to create a main function that:

Takes a patient_id as input.

Runs the SQL queries.

Passes the data to the LLM for report generation.

Converts the output to PDF.

Error Handling

Add checks for missing patient data.

Handle database connection errors gracefully.

Step 6: Test & Refine
Test with sample patient IDs

Verify SQL queries return correct data.

Check if the LLM generates coherent reports.

Ensure the PDF is properly formatted.

Optimize

Adjust the prompt for better medical terminology.

Improve PDF styling (fonts, margins, tables).

Final Instructions for the AI Assistant
First Request:
"Help me write Python code to fetch patient data from PostgreSQL using psycopg2."

Second Request:
"Create a LangChain prompt template for medical report generation."

Third Request:
"Generate code to convert the LLM output into a PDF using reportlab."

Fourth Request:
"Combine all parts into a single script that runs end-to-end."

Key Notes for the AI
Assume: PostgreSQL is already set up with patient data.

Focus: Structured data → LLM → PDF (no RAG needed).

Output: No code, just clear instructions for the AI to follow.