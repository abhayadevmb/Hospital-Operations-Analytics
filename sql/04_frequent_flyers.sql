-- =========================================================================
-- QUESTION 3: Who are the "Frequent Flyer" patients taking up the most 
-- capacity, and what percentage of total hospital days do they consume?
-- =========================================================================
-- BUSINESS CONTEXT:
-- "Frequent Flyers" are patients with multiple, highly complex admissions. 
-- By identifying the top 1% of patients who consume the most hospital days,
-- administrators can assign them dedicated case managers to proactively 
-- handle their outpatient care, thereby massively reducing inpatient costs.

-- SQL SKILLS SHOWCASED: Window Functions (RANK, SUM OVER), CTEs, Subqueries

WITH PatientAggregates AS (
    SELECT 
        patient_nbr,
        COUNT(encounter_id) AS total_visits,
        SUM(time_in_hospital) AS total_days_in_hospital,
        SUM(num_lab_procedures) AS total_labs,
        SUM(num_medications) AS total_meds
    FROM 
        encounters
    GROUP BY 
        patient_nbr
),
RankedPatients AS (
    SELECT 
        patient_nbr,
        total_visits,
        total_days_in_hospital,
        total_labs,
        total_meds,
        RANK() OVER (ORDER BY total_days_in_hospital DESC, total_visits DESC) AS severity_rank
    FROM 
        PatientAggregates
)
SELECT 
    patient_nbr,
    total_visits,
    total_days_in_hospital,
    total_labs,
    total_meds,
    severity_rank
FROM 
    RankedPatients
WHERE 
    severity_rank <= 10
ORDER BY 
    severity_rank;
