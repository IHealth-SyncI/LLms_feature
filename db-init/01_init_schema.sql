-- Users table (AspNetUsers)
CREATE TABLE "AspNetUsers" (
    "Id" VARCHAR(450) PRIMARY KEY,
    "UserName" VARCHAR(256),
    "DOB" DATE,
    "Gender" VARCHAR(50),
    "Address" TEXT,
    "Email" VARCHAR(256),
    "EmailConfirmed" BOOLEAN,
    "PhoneNumber" VARCHAR(50),
    "PhoneNumberConfirmed" BOOLEAN,
    "UserType" VARCHAR(50),
    "Pending" BOOLEAN
);

-- Patients table
CREATE TABLE "Patients" (
    "Patient_ID" VARCHAR(450) PRIMARY KEY,
    "Category" VARCHAR(256) NOT NULL,
    "Family_ID" INT
);

-- MedicalHistories table
CREATE TABLE "MedicalHistories" (
    "MedicalHistory_ID" SERIAL PRIMARY KEY,
    "Patient_ID" INT,
    "Patient_ID1" VARCHAR(450) NOT NULL
);

-- MedicalRecords table
CREATE TABLE "MedicalRecords" (
    "MedicalRecord_ID" SERIAL PRIMARY KEY,
    "MedicalHistory_ID1" INT NOT NULL,
    "Date" DATE NOT NULL,
    "Type" VARCHAR(50) NOT NULL,
    "Category" VARCHAR(256) NOT NULL,
    "Details" TEXT NOT NULL,
    "Diagnosis" TEXT,
    "Treatment" TEXT
);

-- Insert dummy data
INSERT INTO "AspNetUsers" ("Id", "UserName", "DOB", "Gender", "Address", "Email", "EmailConfirmed", "PhoneNumber", "PhoneNumberConfirmed", "UserType", "Pending") VALUES
('patient1', 'John Doe', '1980-01-01', 'Male', '123 Main St', 'john@example.com', TRUE, '555-1234', TRUE, 'Patient', FALSE);

INSERT INTO "Patients" ("Patient_ID", "Category", "Family_ID") VALUES
('patient1', 'Adult', NULL);

INSERT INTO "MedicalHistories" ("Patient_ID", "Patient_ID1") VALUES
(NULL, 'patient1');

INSERT INTO "MedicalRecords" ("MedicalHistory_ID1", "Date", "Type", "Category", "Details", "Diagnosis", "Treatment") VALUES
(1, '2024-05-01', 'Visit', 'General', 'Routine checkup', 'Healthy', 'None'),
(1, '2024-05-10', 'Lab', 'Blood Test', 'Hemoglobin: 14, WBC: 6.0', NULL, NULL); 