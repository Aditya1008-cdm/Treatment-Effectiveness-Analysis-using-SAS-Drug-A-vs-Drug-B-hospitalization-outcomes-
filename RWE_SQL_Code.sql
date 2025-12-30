
-- Patient Journey Analysis

CREATE TABLE diabetes_cohort AS
SELECT patient_id, age, gender
FROM patients
WHERE diagnosis_code='E11';

SELECT patient_id, drug_name,
ROW_NUMBER() OVER (PARTITION BY patient_id ORDER BY start_date) AS therapy_line
FROM drug_exposure;
