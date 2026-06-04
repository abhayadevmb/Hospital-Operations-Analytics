-- =========================================================================
-- QUESTION 4: Which Age Groups have the highest 'Complexity of Care' 
-- and how does that correlate with their Readmission Rate?
-- =========================================================================
-- BUSINESS CONTEXT:
-- Older patients typically have more complex conditions, but is that 
-- complexity resulting in higher readmission rates? Identifying the 
-- relationship between age, medical complexity (labs/meds), and 
-- readmissions allows the hospital to tailor geriatric-specific 
-- care protocols for the highest-risk age buckets.

-- SQL SKILLS SHOWCASED: JOINs, Multi-column Aggregations, Grouping, Ordering

SELECT 
    p.age_midpoint,
    COUNT(e.encounter_id) AS total_admissions,
    ROUND(AVG(e.num_lab_procedures), 2) AS avg_labs,
    ROUND(AVG(e.num_medications), 2) AS avg_meds,
    ROUND(AVG(e.is_readmitted) * 100, 2) AS readmission_rate_percent
FROM 
    encounters e
JOIN 
    patients p ON e.patient_nbr = p.patient_nbr
GROUP BY 
    p.age_midpoint
ORDER BY 
    p.age_midpoint ASC;
