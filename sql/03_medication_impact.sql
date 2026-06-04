-- =========================================================================
-- QUESTION 2: Does changing a patient's medication during their stay 
-- increase their likelihood of being readmitted? 
-- =========================================================================
-- BUSINESS CONTEXT:
-- If patients whose medications are altered ('Ch') have a significantly 
-- higher readmission rate than those whose medications remain stable ('No'), 
-- the hospital might need to implement a "Medication Education" protocol 
-- before discharging those specific patients to prevent bounce-backs.

-- SQL SKILLS SHOWCASED: CTEs (Common Table Expressions), JOINs, Case Statements, Aggregations

WITH MedicationCohorts AS (
    SELECT 
        m.change AS medication_changed,
        COUNT(e.encounter_id) AS total_patients,
        SUM(e.is_readmitted) AS total_readmitted
    FROM 
        encounters e
    JOIN 
        medications m ON e.encounter_id = m.encounter_id
    GROUP BY 
        m.change
)
SELECT 
    medication_changed,
    total_patients,
    total_readmitted,
    ROUND((total_readmitted * 100.0) / total_patients, 2) AS readmission_rate_percent
FROM 
    MedicationCohorts
ORDER BY 
    readmission_rate_percent DESC;
