
-- 1. Patients Dimension
DROP TABLE IF EXISTS patients;
CREATE TABLE patients (
    patient_nbr INT PRIMARY KEY,
    race VARCHAR(50),
    gender VARCHAR(20),
    age_midpoint FLOAT
);

-- 2. Admissions Dimension
DROP TABLE IF EXISTS admissions;
CREATE TABLE admissions (
    encounter_id INT PRIMARY KEY,
    patient_nbr INT,
    admission_type_id INT,
    discharge_disposition_id INT,
    admission_source_id INT,
    payer_code VARCHAR(20),
    medical_specialty VARCHAR(100)
);

-- 3. Diagnoses Dimension
DROP TABLE IF EXISTS diagnoses;
CREATE TABLE diagnoses (
    encounter_id INT PRIMARY KEY,
    patient_nbr INT,
    diag_1 VARCHAR(20),
    diag_2 VARCHAR(20),
    diag_3 VARCHAR(20),
    number_diagnoses INT
);

-- 4. Medications Dimension
DROP TABLE IF EXISTS medications;
CREATE TABLE medications (
    encounter_id INT PRIMARY KEY,
    patient_nbr INT,
    max_glu_serum VARCHAR(20),
    A1Cresult VARCHAR(20),
    metformin VARCHAR(10),
    repaglinide VARCHAR(10),
    nateglinide VARCHAR(10),
    chlorpropamide VARCHAR(10),
    glimepiride VARCHAR(10),
    acetohexamide VARCHAR(10),
    glipizide VARCHAR(10),
    glyburide VARCHAR(10),
    tolbutamide VARCHAR(10),
    pioglitazone VARCHAR(10),
    rosiglitazone VARCHAR(10),
    acarbose VARCHAR(10),
    miglitol VARCHAR(10),
    troglitazone VARCHAR(10),
    tolazamide VARCHAR(10),
    insulin VARCHAR(10),
    "glyburide-metformin" VARCHAR(10),
    "glipizide-metformin" VARCHAR(10),
    "glimepiride-pioglitazone" VARCHAR(10),
    "metformin-rosiglitazone" VARCHAR(10),
    "metformin-pioglitazone" VARCHAR(10),
    change VARCHAR(10),
    diabetesMed VARCHAR(10)
);

-- 5. Encounters Fact
DROP TABLE IF EXISTS encounters;
CREATE TABLE encounters (
    encounter_id INT PRIMARY KEY,
    patient_nbr INT,
    time_in_hospital INT,
    num_lab_procedures INT,
    num_procedures INT,
    num_medications INT,
    number_outpatient INT,
    number_emergency INT,
    number_inpatient INT,
    readmission_status VARCHAR(10),
    is_readmitted INT
);
