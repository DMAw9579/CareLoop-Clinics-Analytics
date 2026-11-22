# CareLoop Clinics – Appointment No-Show Analysis

## Project Overview

CareLoop Clinics is a data analytics project focused on understanding and predicting patient appointment no-shows across multiple clinic locations.

The project uses Python, SQL, Machine Learning, and Generative AI to clean appointment data, identify no-show patterns, predict high-risk appointments, and analyse patient follow-up notes.

**Business Objective:**  
To help clinics reduce missed appointments, improve appointment scheduling, and support better patient follow-up through data-driven insights.

## Technologies Used

- **Programming:** Python
- **Data Analysis:** Pandas, NumPy
- **Data Visualization:** Matplotlib
- **Database:** MySQL
- **Machine Learning:** Scikit-learn
- **Generative AI:** Google Gemini API
- **Data Validation:** Pydantic
- **Development Environment:** Google Colab, Jupyter Notebook
- **Version Control:** Git and GitHub

## Dataset Description

The project uses three original CSV files:

| Dataset | Description |
|---|---|
| appointments.csv | Patient appointment details |
| clinics.csv | Clinic information and locations |
| follow_up.csv | Patient follow-up notes |

The original datasets are stored in the `data/` folder.

## Project Workflow

### Part 1: Data Ingestion and Cleaning

- Loaded CSV data using Python and Pandas.
- Identified missing values, duplicate records, and invalid data.
- Converted date columns into proper datetime formats.
- Standardized booking channel values.
- Handled missing age and distance values using median imputation.
- Applied IQR-based outlier treatment.
- Created new features such as `lead_days` and `no_show`.
- Retrieved clinic weather information using the Open-Meteo API.
- Exported cleaned appointment data and generated SQL insert statements.

**Key Findings:**
- Original appointment records: 1,020.
- Cleaned appointment records: 990.
- Total no-show appointments: 218.
- Overall no-show rate: approximately 22%.

### Part 2: SQL Analysis

Used MySQL to analyse appointment and clinic performance.

Key SQL concepts:
- JOIN operations
- GROUP BY and HAVING
- Aggregate functions
- CASE statements
- Common Table Expressions (CTEs)
- Window functions
- RANK() and LAG()

**Key Findings:**
- Gomti Nagar Care Point had a 33.3% no-show rate, based on 90 appointments.
- Appointments booked 31 or more days in advance had a 60.5% no-show rate.
- The 1–7 day booking group had a 16.2% no-show rate.
- Monthly and clinic-level no-show trends were analysed.

### Part 3: Machine Learning Model

Developed and compared three classification algorithms:

1. Logistic Regression
2. Decision Tree
3. Random Forest

**Feature Engineering:**
- Age
- Distance from clinic
- Appointment fee
- Booking lead time
- Previous no-shows
- Reminder status
- Booking channel
- Visit type

**Model Evaluation:**
- Accuracy
- Precision
- Recall
- F1-score
- ROC-AUC
- Confusion Matrix

**Selected Model:** Logistic Regression

The model was selected based on training-set cross-validation performance.

- Approximate test ROC-AUC: 0.79.
- Selected prediction threshold: 0.35.
- Risk scores were generated for the test dataset.
- High-risk appointments were flagged for possible follow-up calls.

*Note: These are reference results from the project analysis. Confirm them against your final notebook outputs before submission.*

### Part 4: Generative AI Analysis

Used the Google Gemini API to analyse patient follow-up notes and identify possible reasons for missed appointments.

**Allowed Root Cause Categories:**
- forgot_or_no_reminder
- distance_or_transport
- cost_or_fee
- illness_or_emergency
- work_or_schedule
- other

**Implementation:**
- Designed structured prompts using the CRAFT framework.
- Used JSON response formatting.
- Validated responses using Pydantic.
- Checked confidence scores and allowed root cause categories.
- Handled blank notes and invalid API responses.
- Compared simple prompts with structured CRAFT prompts.
- Merged analysed notes with appointment data to examine reminder patterns.

**Important:** The initial run contained invalid Gemini responses for some nonblank notes. Final root-cause findings should be updated after successful API processing and validation.

## Business Recommendations

Based on the appointment analysis:

1. **Prioritize high-risk appointments:** Use the Logistic Regression model and its 0.35 threshold to identify patients who may need follow-up.
2. **Improve reminder communication:** Send timely reminders through suitable communication channels, particularly for patients with previous no-shows.
3. **Focus on advance bookings:** Appointments booked 31 or more days ahead showed a 60.5% no-show rate, indicating a need for additional reminders.
4. **Review clinic performance:** Investigate clinics with higher no-show rates and identify location-specific challenges.
5. **Understand patient concerns:** Use validated follow-up notes to identify transport, cost, illness, scheduling, and reminder-related issues.

The objective is to reduce missed appointments, improve clinic resource utilization, and support better patient experiences.

## Project Limitations

1. Only the first 10 follow-up notes were used for the GenAI demonstration, so they may not represent clinic-wide patient reasons.
2. Data cleaning and outlier treatment were performed before the train-test split, which may introduce data leakage.
3. The same patient may appear in both training and testing datasets, and a random split does not represent a past-to-future evaluation.
4. The selected prediction threshold depends on the clinic's available staff and follow-up call capacity.
5. Model predictions show associations in the available data and do not establish causal relationships.

## Repository Structure

```text
CareLoop-Clinics-Analytics/
│
├── data/
│   ├── appointments.csv
│   ├── clinics.csv
│   └── followup_notes.csv
│
├── 01_ingest_clean.ipynb
├── rejected_rows.json
├── appointments_clean.csv
├── clinics_enriched.csv
├── load_data.sql
├── 02_queries.sql
├── 03_model.ipynb
├── test_risk_scores.csv
├── 04_genai.ipynb
├── notes_analysed.csv
└── README.md
```

## How to Run the Project

### 1. Clone the repository

```bash
git clone https://github.com/DMAw9597/CareLoop-Clinics-Analytics.git
```

### 2. Install required Python libraries

```bash
pip install pandas numpy matplotlib scikit-learn requests google-genai pydantic
```

### 3. Run the notebooks in order

1. `01_ingest_clean.ipynb` – Data ingestion and cleaning.
2. `02_queries.sql` – SQL analysis using MySQL.
3. `03_model.ipynb` – Machine Learning model development.
4. `04_genai.ipynb` – Generative AI analysis of follow-up notes.

### 4. Configure the Gemini API

Create a free API key through Google AI Studio and enter it at runtime when prompted.

**Security:** Never upload your API key, passwords, or secret configuration files to GitHub.

## Conclusion

This project demonstrates an end-to-end data analytics workflow, starting from raw data ingestion and cleaning to SQL analysis, predictive modelling, and Generative AI-based text analysis.

It provides insights into patient appointment behaviour and demonstrates how data-driven approaches can help healthcare organizations identify potential no-shows and improve appointment management.

---

**Project Domain:** Healthcare Analytics  
**Project Type:** End-to-End Data Analytics and Machine Learning  
**Developed Using:** Python | SQL | Machine Learning | Generative AI
