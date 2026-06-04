-- =========================================================================
-- QUESTION 1: Which Medical Specialties handle the highest volume of patients, 
-- and how do their Length of Stay (LOS) and Readmission Rates compare?
-- =========================================================================
-- BUSINESS CONTEXT:
-- Hospital administrators need to know which departments are the busiest and 
-- which ones are struggling with patient flow (Long LOS) or care quality 
-- (High Readmission Rates). This helps in allocating nursing staff and beds.

-- SQL SKILLS SHOWCASED: JOINs, Aggregate Functions, HAVING, ORDER BY

SELECT 
    a.medical_specialty,
    COUNT(e.encounter_id) AS total_admissions,
    ROUND(AVG(e.time_in_hospital), 2) AS avg_length_of_stay_days,
    ROUND(AVG(e.is_readmitted) * 100, 2) AS readmission_rate_percent,
    SUM(e.num_lab_procedures) AS total_lab_procedures
FROM 
    encounters e
JOIN 
    admissions a ON e.encounter_id = a.encounter_id
WHERE 
    a.medical_specialty != 'Missing' -- Filter out unassigned specialties
GROUP BY 
    a.medical_specialty
HAVING 
    COUNT(e.encounter_id) > 500 -- Only look at major departments
ORDER BY 
    total_admissions DESC
LIMIT 10;
