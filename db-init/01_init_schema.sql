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
(1, '2024-05-10', 'Lab', 'Blood Test', 'Hemoglobin: 14, WBC: 6.0', NULL, NULL),

-- ===== CARDIOVASCULAR RECORDS (25) =====
(1, '2020-03-12', 'Visit', 'Cardiology', 'Patient presents with intermittent substernal chest pressure occurring 2-3 times weekly, primarily during moderate exercise. Pain described as squeezing sensation lasting 5-10 minutes, relieved by rest. No associated SOB, nausea, or diaphoresis.', 'Suspected stable angina', 'Prescribed: Nitroglycerin 0.4mg SL PRN chest pain. Ordered stress echocardiogram. Advised to limit vigorous activity.'),
(1, '2020-03-18', 'Procedure', 'Cardiology', 'Exercise stress echocardiogram: Achieved 85% MPHR. ST depression 1.5mm in anterior leads at peak exercise. Echo shows mild anterior wall hypokinesis during stress.', 'Inducible myocardial ischemia', 'Started: Aspirin 81mg daily, Atorvastatin 40mg HS'),
(1, '2020-04-05', 'Visit', 'Cardiology', 'Follow-up for chest pain. Reports 2 episodes since last visit, both triggered by climbing stairs. Nitroglycerin provided complete relief within 3 minutes. Denies nocturnal symptoms.', 'Stable exertional angina', 'Added: Isosorbide mononitrate 30mg daily. Maintain aspirin and statin. Cardiac rehab referral.'),
(1, '2020-06-22', 'Lab', 'Cardiology', 'Lipid panel: Total 210, LDL 110, HDL 38, Trig 175. Liver enzymes: AST 28, ALT 35', 'Suboptimal LDL control', 'Increased: Atorvastatin to 80mg HS. Added: Fenofibrate 145mg daily for hypertriglyceridemia'),
(1, '2020-09-15', 'Visit', 'Cardiology', 'Reports improved exercise tolerance. Only 1 angina episode in past month. BP 146/92 mmHg in office.', 'Uncontrolled hypertension', 'Added: Lisinopril 10mg daily. Advised home BP monitoring twice daily'),
(1, '2021-01-12', 'Visit', 'Cardiology', '3-month follow-up. Home BP average 134/84 mmHg. No angina episodes reported. Mild dry cough noted.', 'ACE inhibitor cough', 'Switched: Losartan 50mg daily instead of Lisinopril'),
(1, '2021-05-20', 'Imaging', 'Cardiology', 'Calcium score CT: Agatston score 185. Moderate calcification in LAD. No coronary dilation.', 'Moderate coronary calcification', 'Continue intensive statin therapy. Repeat lipids in 3 months'),
(1, '2021-08-10', 'Visit', 'Cardiology', 'Complains of lightheadedness. BP 118/74 mmHg. No orthostatic changes. Reports excellent medication adherence.', 'Overcontrolled hypertension', 'Reduced: Losartan to 25mg daily. Recheck BP in 1 week'),
(1, '2022-02-15', 'Procedure', 'Cardiology', 'Cardiac catheterization: 50% mid-LAD stenosis, 30% RCA stenosis. LVEF 55%. Hemodynamics normal.', 'Stable CAD', 'Medical management sufficient. Continue current regimen');
INSERT INTO "MedicalRecords" VALUES (1, '2022-06-30', 'Visit', 'Cardiology', 'Annual follow-up. BP 128/82 mmHg. Denies chest pain. Pedal edema +1 bilaterally.', 'Possible statin myopathy', 'CPK: 210 U/L (normal). Continue Atorvastatin. Add compression stockings');
INSERT INTO "MedicalRecords" VALUES (1, '2022-11-18', 'Lab', 'Cardiology', 'Lipid panel: LDL 78, HDL 42, Trig 150. Liver enzymes normal.', 'Goal LDL achieved', 'Continue current therapy. Next follow-up 6 months');
INSERT INTO "MedicalRecords" VALUES (1, '2023-03-10', 'Visit', 'Cardiology', 'Reports new palpitations - rapid irregular heartbeat lasting 10-15 minutes. No syncope.', 'Suspected paroxysmal AF', 'Ordered: Event monitor for 2 weeks');
INSERT INTO "MedicalRecords" VALUES (1, '2023-03-25', 'Procedure', 'Cardiology', 'Event monitor results: Episode of atrial fibrillation lasting 18 minutes. Average HR 110 bpm during episode.', 'Paroxysmal atrial fibrillation', 'Started: Apixaban 5mg BID. Added: Metoprolol 25mg daily');
INSERT INTO "MedicalRecords" VALUES (1, '2023-07-18', 'Visit', 'Cardiology', 'Follow-up for AF. Reports 2 brief palpitation episodes. BP 130/80 mmHg. INR not applicable (on DOAC).', 'Controlled paroxysmal AF', 'Continue current regimen. Consider ablation if frequency increases');
INSERT INTO "MedicalRecords" VALUES (1, '2024-01-12', 'Visit', 'Cardiology', 'Increased AF episodes to 3-4 weekly. Reports fatigue. BP 140/86 mmHg.', 'Progressive atrial fibrillation', 'Increased: Metoprolol to 50mg daily. Scheduled cardioversion');
INSERT INTO "MedicalRecords" VALUES (1, '2024-02-01', 'Procedure', 'Cardiology', 'Electrical cardioversion: 200J synchronized shock. Immediate restoration of sinus rhythm.', 'Successful cardioversion', 'Post-procedure: Monitor for recurrence. Continue anticoagulation');
INSERT INTO "MedicalRecords" VALUES (1, '2024-03-15', 'Visit', 'Cardiology', '3-week post-cardioversion. No AF recurrence. Reports improved energy levels.', 'Stable sinus rhythm', 'Continue: Apixaban 5mg BID, Metoprolol 50mg daily');
INSERT INTO "MedicalRecords" VALUES (1, '2024-05-10', 'Imaging', 'Cardiology', 'Transesophageal echocardiogram: No atrial thrombus. Mild left atrial enlargement. LVEF 55%.', 'Persistent left atrial remodeling', 'Continue current management. Consider long-term antiarrhythmics');
INSERT INTO "MedicalRecords" VALUES (1, '2024-06-01', 'Lab', 'Cardiology', 'Renal function: eGFR 68 mL/min. Liver enzymes normal. CBC: Hgb 14.2, platelets 210K.', 'Mild renal impairment', 'Adjust: Apixaban to 2.5mg BID due to renal function');
INSERT INTO "MedicalRecords" VALUES (1, '2024-06-15', 'Procedure', 'Cardiology', '24-hour Holter monitor: Sinus rhythm with rare PACs (total 78). No AF recurrence.', 'Controlled arrhythmia', 'Continue current regimen. Follow-up in 3 months');
INSERT INTO "MedicalRecords" VALUES (1, '2024-07-01', 'Visit', 'Cardiology', 'Medication review: Aspirin 81mg, Atorvastatin 80mg, Apixaban 2.5mg BID, Metoprolol 50mg, Fenofibrate 145mg', 'Polypharmacy management', 'Deprescribed: Fenofibrate (improved triglycerides). Added: CoQ10 200mg daily for statin myalgia prophylaxis');

-- ===== ENDOCRINE RECORDS (20) =====
INSERT INTO "MedicalRecords" VALUES (1, '2019-08-15', 'Lab', 'Endocrinology', 'Fasting glucose: 126 mg/dL (high)\nHbA1c: 6.2%\nFasting insulin: 18 μIU/mL (high)\nC-peptide: 2.8 ng/mL', 'Prediabetes with insulin resistance', 'Started: Metformin 500mg BID. Referred to diabetes education program. Recommended 7% weight loss.');
INSERT INTO "MedicalRecords" VALUES (1, '2020-01-20', 'Visit', 'Endocrinology', '3-month follow up: Reports increased polyuria and fatigue. Adhering to medication regimen. Weight down 3kg from initial visit. Fasting fingerstick: 118-132 mg/dL', 'Progressing to Type 2 DM', 'Increased: Metformin to 1000mg BID. Added: Sitagliptin 100mg daily');
INSERT INTO "MedicalRecords" VALUES (1, '2020-05-15', 'Visit', 'Endocrinology', 'Complains of metformin GI side effects. Reports diarrhea 2-3x daily. Taking with meals as directed.', 'Metformin intolerance', 'Switched: Extended-release metformin 1000mg daily. Added: Berberine 500mg TID with meals');
INSERT INTO "MedicalRecords" VALUES (1, '2020-09-10', 'Lab', 'Endocrinology', 'HbA1c: 6.5%, Fasting glucose: 130 mg/dL. Urine microalbumin: 25 mg/g (high)', 'Early diabetic nephropathy', 'Added: Losartan 50mg daily (for renal protection). Tight BP control advised');
INSERT INTO "MedicalRecords" VALUES (1, '2021-04-12', 'Lab', 'Endocrinology', 'HbA1c: 6.4%, Fasting glucose: 128 mg/dL. Urine microalbumin: 45 mg/g (high). C-peptide: 3.1 ng/mL', 'Worsening nephropathy', 'Added: Jardiance 10mg daily. Strict BP control <130/80 advised');
INSERT INTO "MedicalRecords" VALUES (1, '2021-08-30', 'Visit', 'Endocrinology', 'Reports genital mycotic infection. BG monitoring: Fasting 120-140, postprandial 180-220 mg/dL.', 'SGLT2 inhibitor complication', 'Treated: Fluconazole 150mg x1 dose. Continue Jardiance with hygiene education');
INSERT INTO "MedicalRecords" VALUES (1, '2022-02-18', 'Lab', 'Endocrinology', 'HbA1c: 6.8%, Fasting glucose: 142 mg/dL. Urine microalbumin: 60 mg/g', 'Suboptimal diabetes control', 'Added: Basal insulin glargine 10 units HS. Glucose monitoring 4x/day');
INSERT INTO "MedicalRecords" VALUES (1, '2022-06-22', 'Visit', 'Endocrinology', 'Hypoglycemia episodes (58-62 mg/dL) 2-3 times weekly, mostly nocturnal. BG log reviewed.', 'Insulin-induced hypoglycemia', 'Reduced: Glargine to 8 units HS. Added CGM for monitoring');
INSERT INTO "MedicalRecords" VALUES (1, '2022-11-15', 'Lab', 'Endocrinology', 'HbA1c: 6.9%, Time in Range (CGM): 68%. Hypoglycemia: 4% <70 mg/dL', 'Persistent hyperglycemia', 'Added: Prandial insulin lispro 4 units AC breakfast. Adjust per carb count');
INSERT INTO "MedicalRecords" VALUES (1, '2023-03-10', 'Visit', 'Endocrinology', 'New numbness in feet bilaterally. 10g monofilament test abnormal. Vibration sense diminished.', 'Diabetic peripheral neuropathy', 'Started: Gabapentin 300mg HS. Added: Alpha-lipoic acid 600mg daily');
INSERT INTO "MedicalRecords" VALUES (1, '2023-06-20', 'Lab', 'Endocrinology', 'HbA1c: 7.2%, eGFR: 72 mL/min. Urine microalbumin: 85 mg/g', 'Progressive diabetic kidney disease', 'Added: Finerenone 20mg daily. Nephrology referral');
INSERT INTO "MedicalRecords" VALUES (1, '2023-09-18', 'Visit', 'Endocrinology', 'Neuropathy symptoms worsening. Gabapentin ineffective at current dose. Burning pain 6/10 daily.', 'Refractory diabetic neuropathy', 'Increased: Gabapentin to 600mg TID. Added: Duloxetine 30mg daily');
INSERT INTO "MedicalRecords" VALUES (1, '2024-01-12', 'Procedure', 'Endocrinology', 'Autonomic testing: Abnormal heart rate variability. Orthostatic BP drop 25/10 mmHg.', 'Cardiovascular autonomic neuropathy', 'Recommend: Compression stockings. Increase salt/water intake');
INSERT INTO "MedicalRecords" VALUES (1, '2024-03-25', 'Visit', 'Endocrinology', 'Reports erectile dysfunction. SHIM score 12/25. Testosterone: 280 ng/dL (low)', 'Hypogonadism and autonomic neuropathy', 'Started: Testosterone gel 50mg daily. Added: Tadalafil 10mg PRN');
INSERT INTO "MedicalRecords" VALUES (1, '2024-06-20', 'Visit', 'Endocrinology', 'Neuropathy follow-up: Numbness improved in feet but now reports erectile dysfunction. Morning BG 110-140 mg/dL.', 'Diabetic autonomic neuropathy', 'Added: Cialis 5mg daily PRN. Adjusted: Gabapentin to 600mg HS for nocturnal symptoms');

-- ===== MUSCULOSKELETAL RECORDS (15) =====
INSERT INTO "MedicalRecords" VALUES (1, '2021-06-10', 'Visit', 'Orthopedics', 'Right knee pain worsening over 6 months. Pain localized to anterior knee, worse with stairs and prolonged sitting. Mild effusion present. McMurray test negative. Patellar grind test positive.', 'Patellofemoral syndrome with early OA', 'Prescribed: Meloxicam 15mg daily × 30 days. Referred for PT: Quad strengthening program. Recommended knee sleeve for activities');
INSERT INTO "MedicalRecords" VALUES (1, '2021-09-08', 'Physical Therapy', 'Orthopedics', 'Initial PT evaluation: Significant quad weakness (4-/5 R). Limited patellar mobility. Positive Ober test for IT band tightness.', 'Patellofemoral dysfunction', 'PT plan: Quad sets, SLR, patellar mobs, IT band stretching. Home program provided');
INSERT INTO "MedicalRecords" VALUES (1, '2022-01-15', 'Visit', 'Orthopedics', 'PT completed. Reports 50% pain reduction. Minimal effusion. Still painful with stair descent.', 'Improved patellofemoral syndrome', 'Continue home exercise program. As needed: Acetaminophen 1000mg TID PRN');
INSERT INTO "MedicalRecords" VALUES (1, '2022-05-20', 'Procedure', 'Orthopedics', 'US-guided corticosteroid injection: 1mL triamcinolone 40mg + 3mL 1% lidocaine injected into right glenohumeral joint via posterior approach. Immediate pain relief noted.', 'Subacromial bursitis', 'Post-procedure: Ice 20min QID × 2 days. Continue home exercise program. Avoid overhead activities × 2 weeks');
INSERT INTO "MedicalRecords" VALUES (1, '2022-08-18', 'Imaging', 'Orthopedics', 'Right shoulder MRI: Partial thickness supraspinatus tear (7mm). Moderate subacromial bursitis. Mild AC joint arthropathy.', 'Rotator cuff pathology', 'Continue PT. Consider surgery if not improved in 3 months');
INSERT INTO "MedicalRecords" VALUES (1, '2023-01-10', 'Visit', 'Orthopedics', 'Acute onset severe R great toe pain. Joint red, swollen, tender. Unable to bear weight. Recent seafood feast.', 'Suspected gout', 'Prescribed: Colchicine 0.6mg x2 now then 0.6mg BID. Prednisone 40mg daily × 3d');
INSERT INTO "MedicalRecords" VALUES (1, '2023-01-18', 'Lab', 'Rheumatology', 'Uric acid: 9.8 mg/dL. CRP: 4.2 mg/dL. Joint aspirate: Needle-shaped negatively birefringent crystals', 'Acute gouty arthritis', 'Continue colchicine. Start allopurinol 100mg daily after acute episode resolves');
INSERT INTO "MedicalRecords" VALUES (1, '2023-03-22', 'Visit', 'Rheumatology', 'Gout resolved. Reports no recurrent attacks. Uric acid: 7.2 mg/dL.', 'Hyperuricemia', 'Increased: Allopurinol to 200mg daily. Hydration education');
INSERT INTO "MedicalRecords" VALUES (1, '2023-09-18', 'Visit', 'Rheumatology', 'Acute gout flare: Severe pain R 1st MTP joint, erythema, swelling. Unable to bear weight. Last attack 11 months ago.', 'Recurrent gout', 'Prescribed: Prednisone 40mg x3d then taper. Colchicine 0.6mg BID. Increased: Allopurinol to 300mg daily');
INSERT INTO "MedicalRecords" VALUES (1, '2024-02-15', 'Lab', 'Rheumatology', 'Uric acid: 5.8 mg/dL. Renal function stable.', 'Adequate urate control', 'Continue allopurinol 300mg daily. Colchicine 0.6mg daily prophylaxis');
INSERT INTO "MedicalRecords" VALUES (1, '2024-04-10', 'Visit', 'Orthopedics', 'New bilateral hand numbness/waking at night. Positive Tinel sign at wrists. Thenar atrophy absent.', 'Bilateral carpal tunnel syndrome', 'Ordered: EMG/NCS. Wrist splints at night. Avoid repetitive motions');
INSERT INTO "MedicalRecords" VALUES (1, '2024-05-22', 'Procedure', 'Orthopedics', 'EMG/NCS: Moderate right CTS, mild left CTS. Prolonged median motor and sensory latencies right.', 'Confirmed carpal tunnel syndrome', 'Recommended: Right carpal tunnel injection. Surgical consultation if refractory');
INSERT INTO "MedicalRecords" VALUES (1, '2024-06-10', 'Procedure', 'Orthopedics', 'Carpal tunnel injection: 1mL dexamethasone + 1mL lidocaine injected R carpal tunnel. Immediate 50% pain reduction.', 'Moderate carpal tunnel syndrome', 'Post-procedure: Wrist splint at night. Limit repetitive motions. EMG scheduled if no improvement');

-- ===== GASTROINTESTINAL RECORDS (10) =====
INSERT INTO "MedicalRecords" VALUES (1, '2020-02-15', 'Procedure', 'Gastroenterology', 'EGD findings: LA Grade B esophagitis. Biopsy: Negative for Barretts. H. pylori negative. Moderate hiatal hernia.', 'GERD with esophagitis', 'Prescribed: Pantoprazole 40mg BID AC. Baclofen 10mg TID for refractory symptoms. Elevate HOB. Avoid late meals');
INSERT INTO "MedicalRecords" VALUES (1, '2021-03-10', 'Procedure', 'Gastroenterology', 'Colonoscopy: 4 polyps (3 tubular adenomas <5mm, 1 hyperplastic). Complete excision. Diverticulosis in sigmoid.', 'Benign polyps', 'Surveillance: Repeat colonoscopy in 5 years. Increased fiber to 30g/day');
INSERT INTO "MedicalRecords" VALUES (1, '2022-02-18', 'Visit', 'Gastroenterology', 'GERD follow-up. Reports good symptom control on PPI BID. Occasional breakthrough heartburn.', 'Controlled GERD', 'Added: Famotidine 20mg HS. Continue lifestyle modifications');
INSERT INTO "MedicalRecords" VALUES (1, '2022-07-15', 'Lab', 'Gastroenterology', 'LFTs: ALT 65, AST 60, Alk Phos 110. US: Hepatic steatosis. No biliary dilation.', 'NAFLD with transaminitis', 'Recommended: Weight loss, vitamin E 400IU daily. Repeat LFTs 3 months');
INSERT INTO "MedicalRecords" VALUES (1, '2022-11-30', 'Lab', 'Gastroenterology', 'FibroTest: ActiTest 0.45, SteatoTest 0.78. ALT 55. US: Moderate hepatomegaly with fatty infiltration', 'NASH with stage 2 fibrosis', 'Prescribed: Vitamin E 800IU daily. Pioglitazone 15mg daily off-label');
INSERT INTO "MedicalRecords" VALUES (1, '2023-04-20', 'Visit', 'Gastroenterology', 'Reports constipation. BM every 3-4 days. Straining. No bleeding. Abdomen soft, non-tender.', 'Constipation-predominant IBS', 'Started: Linaclotide 145mcg daily. Increase water/fiber intake');
INSERT INTO "MedicalRecords" VALUES (1, '2023-07-10', 'Visit', 'Gastroenterology', 'Complains of RUQ discomfort and bloating after fatty meals. US: Hepatic steatosis. LFTs: ALT 68, AST 54, Alk Phos 110.', 'NAFLD with mild transaminitis', 'Started: Vitamin E 800IU daily. Recommended Mediterranean diet. Repeat LFTs in 3 months');
INSERT INTO "MedicalRecords" VALUES (1, '2024-01-18', 'Lab', 'Gastroenterology', 'LFTs: ALT 58, AST 50. FibroScan: CAP 320 dB/m, E 8.2 kPa', 'Persistent NASH without advanced fibrosis', 'Continue vitamin E and pioglitazone. Weight loss goal 10%');
INSERT INTO "MedicalRecords" VALUES (1, '2024-05-05', 'Visit', 'Gastroenterology', 'Complains of new constipation alternating with diarrhea. Calprotectin 45 μg/g. Negative Celiac panel.', 'IBS-Mixed type', 'Started: Linzess 145mcg daily. Added: IBgard TID PRN. Low FODMAP diet initiated');

-- ===== PREVENTATIVE/GENERAL RECORDS (30) =====
INSERT INTO "MedicalRecords" VALUES (1, '2018-05-15', 'Visit', 'General', 'Annual physical: BP 130/84, BMI 26.4. No complaints. Family history: Father MI at 60, mother T2DM.', 'Low cardiovascular risk', 'Recommend: Lifestyle maintenance. Baseline labs ordered');
INSERT INTO "MedicalRecords" VALUES (1, '2019-05-20', 'Visit', 'General', 'Annual physical: BP 132/86, BMI 27.1. Reports stress at work. PHQ-9: 5/27 (mild).', 'Mild depressive symptoms', 'Recommended: Exercise 30min 5x/week. Mindfulness training');
INSERT INTO "MedicalRecords" VALUES (1, '2020-05-18', 'Visit', 'General', 'Annual physical: BP 140/90, BMI 28.3. Fasting glucose 118 mg/dL. Weight gain 5kg in 1 year.', 'Prediabetes, obesity', 'Referred: Endocrinology. Intensive lifestyle intervention');
INSERT INTO "MedicalRecords" VALUES (1, '2021-05-12', 'Visit', 'General', 'Annual physical: BP 138/88, BMI 28.7. Reports snoring, daytime fatigue. ESS: 10/24.', 'Possible sleep apnea', 'Ordered: Home sleep study');
INSERT INTO "MedicalRecords" VALUES (1, '2022-05-10', 'Visit', 'General', 'Annual physical: BP 136/84, BMI 29.1. Med review: Metformin, Atorvastatin, Losartan. Labs pending.', 'Stable chronic conditions', 'Preventative: Pneumovax administered. Shingrix scheduled');
INSERT INTO "MedicalRecords" VALUES (1, '2023-01-10', 'Visit', 'General', 'Annual physical: BP 138/86, BMI 29.7, waist circumference 42in. Screening PHQ-9: 4/27. Concerned about paternal history of prostate CA.', 'Essential hypertension\nObesity', 'Prescribed: Losartan 50mg daily. Added: Finasteride 5mg daily for BPH prophylaxis. Scheduled PSA');
INSERT INTO "MedicalRecords" VALUES (1, '2023-03-18', 'Procedure', 'Dermatology', 'Excision 3mm pigmented lesion left scapula. Borders clinically clear. Depth to superficial fat.', 'Compound nevus with mild atypia', 'Wound care: Silvadene BID. Follow up in 6 months for full skin exam');
INSERT INTO "MedicalRecords" VALUES (1, '2023-02-22', 'Visit', 'Pulmonology', 'Sleep study: AHI 18/hr, SaO2 nadir 88%. Reports snoring, daytime fatigue. ESS score 12/24.', 'Moderate OSA', 'Prescribed: AutoCPAP 5-15cm H2O. Added: Oxygen bleed 2L/min for hypoxemia');
INSERT INTO "MedicalRecords" VALUES (1, '2023-07-15', 'Visit', 'Ophthalmology', 'Dilated exam: Mild NPDR OU. Cup:disc 0.3 OU. IOP 18 OU. Visual fields full.', 'Early diabetic retinopathy', 'Recommend: Annual retinal exams. Tight glycemic control (A1c<7%)');
INSERT INTO "MedicalRecords" VALUES (1, '2024-01-15', 'Visit', 'General', 'Annual physical: BP 142/88, BMI 29.8. Reports new palpitations. PMHx reviewed.', 'New cardiac symptoms', 'Referred: Cardiology. ECG ordered');
INSERT INTO "MedicalRecords" VALUES (1, '2024-03-25', 'Procedure', 'Urology', 'PSA: 1.8 ng/mL (up from 1.5 last year). Digital rectal exam: Prostate 30g, smooth, no nodules.', 'Benign prostatic enlargement', 'Continue finasteride. Repeat PSA in 6 months');
INSERT INTO "MedicalRecords" VALUES (1, '2024-04-12', 'Visit', 'Dentistry', 'Periodontal exam: Generalized 4-5mm pockets. Calculus moderate. Gingival inflammation.', 'Moderate chronic periodontitis', 'Scaling/root planing completed. Oral hygiene instruction');
INSERT INTO "MedicalRecords" VALUES (1, '2024-05-20', 'Immunization', 'General', 'Administered: Tdap booster, Pneumovax 23. Vaccine history reviewed.', 'Vaccine updates', 'Next due: Influenza Oct 2024, Shingrix dose 2');
INSERT INTO "MedicalRecords" VALUES (1, '2024-06-25', 'Immunization', 'General', 'Administered: Shingrix dose 2 (completed series), COVID-19 bivalent booster', 'Vaccine updates', 'Next due: Influenza Oct 2024. Vaccine record updated');
INSERT INTO "MedicalRecords" VALUES (1, '2024-07-01', 'Visit', 'General', 'Current medications:
1. Cardiac: Apixaban 2.5mg BID, Metoprolol 50mg daily, Rosuvastatin 20mg HS
2. Endocrine: Metformin XR 1000mg BID, Jardiance 25mg daily, Gabapentin 600mg HS
3. GI: Linzess 145mcg daily, Pantoprazole 40mg daily
4. MSK: Allopurinol 300mg daily, Celecoxib 200mg PRN
5. Supplements: Vit D3 2000IU, Vit E 400IU, Fish oil 1g daily
6. PRN: Nitroglycerin 0.4mg SL, Cialis 5mg', 'Polypharmacy management', 'Deprescribed: Sitagliptin (redundant with Jardiance). Reduced: Gabapentin morning dose. Added: CoQ10 100mg for statin myalgia');