-- =========================================================================
-- QUESTION 5: Logistics & Flow - Which Admission Sources and Discharge 
-- Dispositions are the primary drivers of readmissions?
-- =========================================================================
-- BUSINESS CONTEXT:
-- Understanding the "source" and "exit" of a patient stay is critical for 
-- operational efficiency. If patients from the Emergency Room (Source 7) 
-- are bouncing back at higher rates than Physician Referrals (Source 1), 
-- it indicates a need for better screening at the "front door." 
-- Similarly, if patients sent to Nursing Homes (Disposition 3) are 
-- returning, the coordination with those facilities needs to be audited.

-- SQL SKILLS SHOWCASED: CASE Statements (Categorization), Joins, Multi-level Aggregation

SELECT 
    CASE 
        WHEN a.admission_source_id = 7 THEN 'Emergency Room'
        WHEN a.admission_source_id = 1 THEN 'Physician Referral'
        ELSE 'Other Source'
    END AS admission_intake,
    CASE 
        WHEN a.discharge_disposition_id = 1 THEN 'Discharged to Home'
        WHEN a.discharge_disposition_id = 11 THEN 'Expired (Deceased)'
        WHEN a.discharge_disposition_id IN (3, 6) THEN 'Discharged to Care Facility'
        ELSE 'Other Exit'
    END AS discharge_destination,
    COUNT(e.encounter_id) AS total_admissions,
    ROUND(AVG(e.time_in_hospital), 2) AS avg_length_of_stay,
    ROUND(AVG(e.is_readmitted) * 100, 2) AS readmission_rate_percent
FROM 
    encounters e
JOIN 
    admissions a ON e.encounter_id = a.encounter_id
WHERE 
    a.discharge_disposition_id != 11 -- Exclude deceased patients from readmission stats
GROUP BY 
    admission_intake, discharge_destination
ORDER BY 
    readmission_rate_percent DESC;
