# Hospital Operations & Patient Flow Analytics

## 🏥 Project Overview
Hospital systems face constant pressure to manage bed capacity, reduce wait times, and allocate staff efficiently. Inefficient patient flow doesn't just increase costs—it directly impacts the quality of patient care.

This project focuses on building an end-to-end analytical pipeline that transforms raw hospital data into actionable operational strategy. By identifying bottlenecks and tracking KPIs like Length of Stay (LOS) and Readmission Rates, this analysis provides a data-driven framework for improving hospital throughput and patient outcomes.

## 🗂️ Project Structure
*   `data/raw/`: Original datasets.
*   `data/processed/`: Normalized and cleaned tables ready for analysis.
*   `notebooks/`: Python notebooks for data cleaning and Exploratory Data Analysis (EDA).
*   `sql/`: Advanced SQL scripts containing the core business logic.
*   `dashboards/`: Power BI visualization files.

## 🛠️ Tech Stack
*   **Python:** Used for data normalization, handling missing values, and feature engineering.
*   **SQL (PostgreSQL):** Utilized for complex modeling involving CTEs and Window Functions.
*   **Power BI:** Developed interactive dashboards for executive reporting.

## 📊 Operational Insights & Strategic Recommendations

### 1. Identifying Departmental Bottlenecks
**Analysis:** Comparing patient volume against outcomes across medical specialties reveals significant pressure points. **Nephrology** presents the highest operational risk, with an average stay of 5.02 days and a readmission rate of 56.66%. Similarly, **Emergency/Trauma** handles the second-highest patient volume (7,565) but suffers from a 50.92% readmission rate.

**Strategic Recommendation:** To improve bed turnover, administrators should prioritize post-discharge follow-up resources for Nephrology and Emergency/Trauma. Implementing proactive nursing calls for these patients can help reduce the 50%+ readmission rate and free up critical capacity for new admissions.

### 2. Clinical Impact of Medication Transitions
**Analysis:** A key operational question was whether changing a patient's medication during their stay impacts their recovery. The data shows that patients with medication changes (**Ch**) have a readmission rate of **48.56%**, compared to **43.96%** for those with stable routines. This 5% increase suggests that new medication protocols are a significant driver of hospital bounce-backs.

**Strategic Recommendation:** The hospital should introduce a "Transition Education" protocol. Patients undergoing medication changes should receive a mandatory 10-minute consultation with a pharmacist before discharge. Ensuring patients understand their new prescriptions can directly lower the readmission risk.

### 3. High-Utilization "Frequent Flyer" Analysis
**Analysis:** By ranking patients using window functions, we identified that a small subset of "Frequent Flyers" consumes a disproportionate share of hospital resources. The top 10 patients alone accounted for over **1,400 hospital days** and nearly **10,000 lab procedures**. One patient (ID: 84428613) spent 6 months of the year in a hospital bed across 22 separate visits.

**Strategic Recommendation:** Implementing a "High-Utilization Case Management" program is essential. Assigning dedicated outpatient coordinators to the top 1% of users can manage their chronic conditions more effectively at home, potentially freeing up hundreds of bed-days for the broader community.

### 4. Correlation Between Age and Care Complexity
**Analysis:** While clinical complexity (labs and medications) peaks in the 55-75 age range, the highest readmission risk (48.16%) is concentrated in the **75-85 age group**. Additionally, a concerning 39.8% readmission rate was found in the **15-25 age range**, despite these patients having lower medication requirements.

**Strategic Recommendation:**
*   **Senior Care:** The high readmission rate for patients 75+ suggests a need for "Step-Down" recovery environments to bridge the gap between hospital and home.
*   **Youth Engagement:** The high risk in younger patients points to a possible "adherence gap." Tailoring communication—such as through a mobile health app—could improve home management for this younger demographic.

### 5. Logistical Flow & Discharge Bottlenecks
**Analysis:** Analyzing the "Intake-to-Exit" flow identified that patients admitted through the **Emergency Room** and discharged to a **Care Facility** (Nursing Home/SNF) represent the most vulnerable cohort, with a **55.06% readmission rate**. In contrast, physician referrals discharged to home had the best outcomes (41.2% readmission).

**Strategic Recommendation:**
*   **Facility Audits:** The hospital should audit third-party care facility partners to ensure they can adequately support complex diabetic patients.
*   **ER Discharge Liaison:** Establishing a dedicated coordinator for ER-admitted patients to manage the transition to care facilities can improve hand-off quality and reduce the 55% bounce-back rate.

## 📈 Executive Dashboard (Power BI)
The final deliverable is a 3-page interactive Power BI dashboard connected directly to the PostgreSQL database. The data model follows a Star Schema with `encounters` as the central Fact Table and `patients`, `admissions`, `diagnoses`, and `medications` as surrounding Dimension Tables.

### DAX Measures
Beyond simple aggregations, the dashboard uses several calculated measures to surface operational insights dynamically:
*   **Readmission Rate %** — Uses `DIVIDE` to calculate the proportion of readmitted patients, responding to any active filter on the page.
*   **ER Readmission Rate %** — A `CALCULATE`-filtered measure isolating only Emergency Room admissions to benchmark ER-specific outcomes.
*   **High Frequency Patients** — Combines `DISTINCTCOUNT` with `FILTER` and `VALUES` to count patients with more than 3 hospital visits.
*   **LOS Variance vs Hospital Avg** — Uses `VAR` and `ALL` to compare a filtered department's average stay against the hospital-wide benchmark.

### Page 1: Operations Overview
Provides a high-level snapshot of hospital performance. Four KPI cards display Total Admissions (102K), Average Length of Stay (4.40 days), Readmission Rate (46.1%), and Frequent Flyer count (3K). A Scatter Chart plots each department's volume against its readmission rate, making it easy to spot high-volume, high-risk specialties at a glance. A Bar Chart breaks down readmission risk by age group with a reference line marking the hospital average. The bottom row features a conditional-formatted Matrix showing the top 10 departments ranked by admissions, and a Donut Chart illustrating the split between patients whose medications were changed versus those who remained stable.

### Page 2: Clinical Care Quality
Focuses on the clinical drivers behind readmissions. KPI cards highlight the average number of lab procedures per visit (43.10), ER-specific readmission rate (49.4%), and average medications per visit (16.02). A Gauge Chart compares the hospital's current 46.1% readmission rate against a 35% quality target, making the performance gap immediately visible. A Bar Chart compares readmission rates across insulin dosage categories (Down, Up, Steady, No). The bottom section includes a table of the Top 15 highest-utilization patients with conditional formatting on Total Bed Days, and a Donut Chart exposing A1C test coverage—revealing that the vast majority of diabetic patients leave the hospital without an A1C test being administered.

### Page 3: Patient Flow & Discharge
Maps the full patient journey from intake to exit. KPI cards show ER Intake Rate (56.5%), Home Discharge Rate (59.2%), and Care Facility Transfer Rate (26.4%). A Funnel Chart visualizes patient volume at each discharge pathway, clearly showing that 60K patients go home while smaller volumes flow to nursing facilities and short-term hospitals. A Column Chart compares readmission rates across admission sources (Emergency Room, Physician Referral, HMO, etc.). A cross-tabulation Matrix with conditional formatting maps every Admission Source against every Discharge Destination, directly proving the "ER → Nursing Facility" bottleneck identified in the SQL analysis. Dropdown slicers for Payer Type and Gender allow dynamic filtering across the entire page.

The `.pbix` file is in the `dashboards/` folder for anyone who wants to explore it in Power BI Desktop.
