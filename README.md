# Hospital Operations & Patient Flow Analytics

## Project Overview
Managing bed capacity, patient flow, and staff allocation is a constant challenge for hospital administrators. When patient throughput is inefficient, it drives up operating costs and can directly compromise clinical outcomes. 

This project implements an end-to-end data pipeline to clean, model, and analyze raw hospital encounter records, focusing on diabetic inpatient admissions. The primary objective is to identify systemic bottlenecks, analyze metrics like Length of Stay (LOS) and Readmission Rates, and translate these data points into actionable strategies to improve hospital operations and patient care.

## Project Structure
*   `data/raw/` - Raw datasets.
*   `data/processed/` - Normalized, cleaned CSV files ready for database import.
*   `notebooks/` - Jupyter notebooks detailing data cleaning, normalization, and exploratory analysis.
*   `sql/` - PostgreSQL scripts containing analytical queries and cohort definitions.
*   `dashboards/` - Power BI dashboard file (.pbix) showcasing operational and clinical metrics.

## Tech Stack
*   **Python (pandas, numpy):** Used to clean raw encounter data, handle missing values, and normalize the flat schema.
*   **SQL (PostgreSQL):** Used for advanced modeling, cohort analysis, and metric calculations using multi-table joins, CTEs, and window functions.
*   **Power BI:** Used to build an interactive multi-page dashboard, using DAX for dynamic measures and executive reporting.

## Key Insights & Strategic Recommendations

### 1. Departmental Bottlenecks
Comparing admission volumes and outcomes across medical specialties highlighted critical pressure points in patient throughput:
*   **Nephrology** shows the highest operational risk. Patients experience an average stay of 5.02 days, and 56.66% are readmitted.
*   **Emergency/Trauma** handles the second-highest patient volume (7,565 admissions) but has a high readmission rate of 50.92%.

**Strategy:** Target Nephrology and Emergency/Trauma with post-discharge follow-up resources. Implementing dedicated nursing check-ins or telehealth follow-ups within 48 hours of discharge could reduce these high readmission rates and free up bed capacity.

### 2. Clinical Impact of Medication Changes
Changing a patient's medication routine during their stay correlates with a higher readmission rate. Patients whose medication regimens were adjusted (marked as 'Ch') had a **48.56%** readmission rate, compared to **43.96%** for those whose medications remained stable. This 4.6% absolute increase suggests that changes in treatment protocols add risk during transition of care.

**Strategy:** Implement a mandatory pharmacist consult prior to discharge for any patient undergoing medication adjustments. Ensuring that patients fully understand their new prescriptions and dosing schedules can prevent avoidable readmissions.

### 3. High-Utilization "Frequent Flyers"
A small group of chronic patients consumes a disproportionate share of hospital resources. Using window functions to rank patients by admission frequency showed that the top 10 patients alone accounted for over **1,400 bed-days** and nearly **10,000 lab procedures**. The most extreme patient (ID: 84428613) was admitted 22 times and spent a total of 180 days in the hospital over the year.

**Strategy:** Establish a high-utilization case management program. Assigning outpatient coordinators to proactively manage the care of the top 1% of frequent flyers can improve their quality of life while freeing up hundreds of bed-days.

### 4. Age vs. Care Complexity
Although clinical complexity (number of lab procedures and medications) peaks in the 55-75 age range, readmissions do not follow the same curve:
*   **Seniors (75-85):** Experience the highest readmission rate (48.16%), despite having similar clinical complexity to younger groups.
*   **Youth (15-25):** Have a surprisingly high readmission rate of 39.8%, despite having very low medication requirements.

**Strategy:** 
For the 75-85 age group, the high readmission rate indicates a need for transitional care options, such as home health visits or coordinated transitions to skilled nursing facilities. For the 15-25 age group, the discrepancy points to potential treatment adherence gaps. Tailoring communication (e.g., text reminders or mobile health apps) could improve self-management.

### 5. Logistical Flow & Discharge Destinations
Analyzing the flow from admission to discharge revealed a major bottleneck: patients admitted through the **Emergency Room** and discharged to **Care Facilities** (such as nursing homes or rehabilitation centers) have a **55.06% readmission rate**. By comparison, physician-referred patients discharged directly to their homes had the lowest readmission rate at 41.2%.

**Strategy:** 
Audit patient transitions to partner care facilities to verify they are equipped to handle complex diabetic post-discharge care. Additionally, placing a dedicated ER transition liaison to coordinate these specific facility transfers can improve hand-off quality.

---

## Executive Dashboard (Power BI)
The dashboard connects directly to the PostgreSQL database. The data model is structured as a Star Schema, centered on the `encounters` fact table with links to dimension tables for `patients`, `admissions`, `diagnoses`, and `medications`.

### Core DAX Measures
The dashboard uses dynamic DAX measures to calculate operational and clinical KPIs:
*   **Readmission Rate %** - Computes the proportion of readmitted patients, adjusting dynamically to any active page filters.
*   **ER Readmission Rate %** - Isolates admissions originating from the Emergency Department to benchmark ER-specific outcomes.
*   **High Frequency Patients** - Identifies patients with more than 3 hospital visits by combining `DISTINCTCOUNT` with `FILTER` and `VALUES`.
*   **LOS Variance vs Hospital Avg** - Compares a department’s average stay length against the hospital-wide average using variables and `ALL`.

### Page 1: Operations Overview
Provides a high-level snapshot of overall performance.
*   **KPI Cards:** Display Total Admissions (102K), Average Length of Stay (4.40 days), Readmission Rate (46.1%), and the count of Frequent Flyers (3K).
*   **Visuals:** A scatter chart plots departments by admission volume against readmission rate to highlight high-risk specialties. A bar chart breaks down readmissions by age group against the hospital average line.
*   **Details:** The bottom section features a matrix of the top 10 departments by admission volume and a donut chart showing the split between patients with changed vs. stable medication routines.

### Page 2: Clinical Care Quality
Focuses on clinical metrics, testing compliance, and outcomes.
*   **KPI Cards:** Show average lab procedures per visit (43.10), ER-specific readmissions (49.4%), and average medications per visit (16.02).
*   **Visuals:** A gauge chart measures the current 46.1% readmission rate against a 35% target. A bar chart compares readmissions across insulin dosage changes (Up, Down, Steady, No).
*   **Details:** Includes a matrix listing the top 15 highest-utilization patients (with conditional formatting on Total Bed Days) and a donut chart showing A1C test coverage, highlighting a significant gap in diabetic testing prior to discharge.

### Page 3: Patient Flow & Discharge
Tracks patient movement into and out of the hospital system.
*   **KPI Cards:** Monitor ER Intake Rate (56.5%), Home Discharge Rate (59.2%), and Care Facility Transfer Rate (26.4%).
*   **Visuals:** A funnel chart shows patient distribution across discharge pathways (dominated by the 60K home discharges). A column chart displays readmission rates by admission source.
*   **Details:** A cross-tabulation matrix maps admission sources against discharge destinations, visually highlighting the high-risk "ER → Care Facility" flow. Payer Type and Gender slicers allow interactive filtering across the page.

The interactive `.pbix` file is available in the `dashboards/` folder.
