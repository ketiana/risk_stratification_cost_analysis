
-- Query 1: Patient Population scope
SELECT
    CASE
        WHEN patients.DEATHDATE IS NULL THEN 'Living'
        ELSE 'Deceased'
    END AS status,
    COUNT(*) AS count,
    ROUND(AVG(INCOME), 2) AS avg_income,
    MIN(BIRTHDATE) AS oldest_birthdate,
    MAX(BIRTHDATE) AS youngest_birthdate
FROM patients
GROUP BY status;

-- Query 2 Encounter class distribution and cost
SELECT
    encounters.ENCOUNTERCLASS,
    COUNT(*) AS encounter_count,
    COUNT(DISTINCT PATIENT) AS unique_patients,
    ROUND(AVG(TOTAL_CLAIM_COST), 2) AS avg_cost,
    ROUND(SUM(TOTAL_CLAIM_COST), 2) AS total_cost
FROM encounters
GROUP BY ENCOUNTERCLASS
ORDER BY total_cost DESC;
-- Wellness and ambulatory drive the most total cost

-- Query 3 Payer cost summary
SELECT
    py.NAME AS payer,
    COUNT(DISTINCT e.PATIENT) AS members,
    ROUND(SUM(e.TOTAL_CLAIM_COST), 2) AS total_claims,
    ROUND(SUM(e.PAYER_COVERAGE), 2) AS total_covered,
    ROUND(AVG(
            e.PAYER_COVERAGE / NULLIF(e.TOTAL_CLAIM_COST, 0)
          ) * 100, 1) AS avg_coverage_pc
FROM encounters e
JOIN payers py ON e.PAYER = py.Id
GROUP BY py.NAME
ORDER BY total_claims DESC;