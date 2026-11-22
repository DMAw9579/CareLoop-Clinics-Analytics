CREATE DATABASE noshowguard;
USE noshowguard;

-- TASK 2.1: Build and load dataset
-- create clinic table
CREATE TABLE clinics (
    clinic_id VARCHAR(5) PRIMARY KEY,
    clinic_name VARCHAR(40) NOT NULL,
    city VARCHAR(20) NOT NULL,
    tier VARCHAR(10),
    latitude DECIMAL(8,4),
    longitude DECIMAL(8,4),
    temp_c DECIMAL(5,1)
);


-- create appointment table
CREATE TABLE appointment (
    appointment_id VARCHAR(8) PRIMARY KEY,
    patient_id VARCHAR(8) NOT NULL,
    clinic_id VARCHAR(5) NOT NULL,
    booked_on DATE,
    appt_date DATE,
    age INT,
    gender VARCHAR(1),
    distance_km DECIMAL(5,1),
    fee_inr INT,
    booking_channel VARCHAR(10),
    visit_type VARCHAR(12),
    reminder_sent VARCHAR(3),
    prior_no_shows INT,
    status VARCHAR(10),
    lead_days INT,
    no_show INT,

    FOREIGN KEY (clinic_id)
    REFERENCES clinics(clinic_id)
);

-- verify records
SELECT COUNT(*) AS total_clinics
FROM clinics;

SELECT COUNT(*) AS total_appointments
FROM appointment;

SELECT SUM(no_show) AS total_no_shows
FROM appointment;


-- test duplicate primary key
INSERT INTO appointments
VALUES (
    'A0001',
    'P196',
    'C05',
    '2025-01-22',
    '2025-01-25',
    25,
    'F',
    5.0,
    500,
    'App',
    'Consultation',
    'Yes',
    0,
    'Attended',
    3,
    0
);


-- TASK 2.2: No-show rate by clinic
SELECT
    c.clinic_name,
    c.city,
    COUNT(a.appointment_id) AS appointment,
    SUM(a.no_show) AS no_shows,
    ROUND(
        100.0 * SUM(a.no_show) /
        COUNT(a.appointment_id),
        1
    ) AS no_show_pct
FROM appointment a
JOIN clinics c
    ON a.clinic_id = c.clinic_id
GROUP BY
    c.clinic_id,
    c.clinic_name,
    c.city
HAVING COUNT(a.appointment_id) >= 95
ORDER BY no_show_pct DESC;


-- Find the highest rate across all 8 clinics
SELECT
    c.clinic_name,
    c.city,
    COUNT(a.appointment_id) AS appointments,
    SUM(a.no_show) AS no_shows,
    ROUND(
        100.0 * SUM(a.no_show) /
        COUNT(a.appointment_id),
        1
    ) AS no_show_pct
FROM appointments a
JOIN clinics c
    ON a.clinic_id = c.clinic_id
GROUP BY
    c.clinic_id,
    c.clinic_name,
    c.city
ORDER BY no_show_pct DESC;


-- Task 2.3 – Does booking far ahead matter?
SELECT
    CASE
        WHEN lead_days <= 7 THEN '1-7'
        WHEN lead_days <= 14 THEN '8-14'
        WHEN lead_days <= 30 THEN '15-30'
        ELSE '31+'
    END AS lead_band,
    COUNT(*) AS appointment,
    SUM(no_show) AS no_shows,
    ROUND(
        100.0 * SUM(no_show) / COUNT(*),
        1
    ) AS no_show_pct
FROM appointment
GROUP BY lead_band
ORDER BY MIN(lead_days);


-- Task 2.4 – Month-by-month trend
WITH monthly AS (
SELECT
        SUBSTR(CAST(appt_date AS CHAR), 1, 7) AS month,
        COUNT(*) AS appointment,
        ROUND(
            100.0 * SUM(no_show) / COUNT(*),
            1
        ) AS no_show_pct
        FROM appointment
    GROUP BY SUBSTR(CAST(appt_date AS CHAR), 1, 7)
)
SELECT
    month,
    appointment,
    no_show_pct,
    ROUND(
        no_show_pct -
        LAG(no_show_pct) OVER (ORDER BY month),
        1
    ) AS change_percentage_points
FROM monthly
ORDER BY month;


-- Task 2.5 – Rank clinics inside each city
WITH clinic_rates AS (
	SELECT
        c.clinic_name,
        c.city,
        ROUND(
            100.0 * SUM(a.no_show) /
            COUNT(a.appointment_id),
            1
        ) AS no_show_pct
	FROM appointment a
    JOIN clinics c
        ON a.clinic_id = c.clinic_id
	GROUP BY
        c.clinic_id,
        c.clinic_name,
        c.city
)
SELECT
    clinic_name,
    city,
    no_show_pct,
    RANK() OVER (
        PARTITION BY city
        ORDER BY no_show_pct DESC
    ) AS rank_in_city,
    CASE
        WHEN no_show_pct > (
            SELECT
                100.0 * SUM(no_show) / COUNT(*)
            FROM appointment
        )
        THEN 'above'
        WHEN no_show_pct < (
            SELECT
                100.0 * SUM(no_show) / COUNT(*)
            FROM appointment
        )
        THEN 'below'
        ELSE 'equal'
    END AS vs_overall
FROM clinic_rates
ORDER BY city, rank_in_city;















