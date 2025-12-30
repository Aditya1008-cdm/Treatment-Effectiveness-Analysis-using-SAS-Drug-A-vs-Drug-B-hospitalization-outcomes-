
/* RWE Treatment Effectiveness Analysis */

PROC IMPORT DATAFILE="patients.csv" OUT=patients DBMS=CSV REPLACE; GETNAMES=YES; RUN;
PROC IMPORT DATAFILE="drug_exposure.csv" OUT=drug DBMS=CSV REPLACE; GETNAMES=YES; RUN;
PROC IMPORT DATAFILE="hospitalizations.csv" OUT=hosp DBMS=CSV REPLACE; GETNAMES=YES; RUN;

DATA cohort;
MERGE patients drug;
BY patient_id;
RUN;

PROC FREQ DATA=cohort;
TABLES drug_name*gender;
RUN;

PROC SQL;
CREATE TABLE outcome AS
SELECT a.patient_id, a.drug_name,
CASE WHEN b.admit_date IS NOT NULL THEN 1 ELSE 0 END AS hosp_flag
FROM cohort a LEFT JOIN hosp b
ON a.patient_id=b.patient_id;
QUIT;

PROC SQL;
SELECT drug_name, AVG(hosp_flag) AS hosp_rate
FROM outcome GROUP BY drug_name;
QUIT;
