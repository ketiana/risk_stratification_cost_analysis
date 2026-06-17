
CREATE OR REPLACE VIEW member_cost_summary AS
WITH encounter_costs AS (
    -- Aggregate encounter costs and utilization per patient
    SELECT
        PATIENT,
        COUNT(*) AS total_encounters,
        ROUND(SUM(TOTAL_CLAIM_COST), 2) AS total_encounter_costs,
        ROUND(SUM(PAYER_COVERAGE), 2) AS encounter_payer_covered,
        ROUND(SUM(TOTAL_CLAIM_COST-PAYER_COVERAGE), 2) AS encounter_payer_outofpocket,
        SUM(CASE WHEN ENCOUNTERCLASS = 'emergency' THEN 1 ELSE 0 END) AS emergency_count,
        SUM(CASE WHEN ENCOUNTERCLASS = 'inpatient' THEN 1 ELSE 0 END) AS inpatient_count,
        SUM(CASE WHEN ENCOUNTERCLASS = 'wellness' THEN 1 ELSE 0 END) AS wellness_count,
        SUM(CASE WHEN ENCOUNTERCLASS = 'ambulatory' THEN 1 ELSE 0 END) AS ambulatory_count
    FROM encounters
    GROUP BY PATIENT
),
medication_costs AS (
    -- Aggregate medication costs per patient
    SELECT
        PATIENT,
        COUNT(*) AS prescription_count,
        ROUND(SUM(TOTALCOST), 2) AS total_prescription_cost,
        ROUND(SUM(PAYER_COVERAGE), 2) AS prescription_payer_covered
    FROM medications
    GROUP BY PATIENT
       HAVING ROUND(SUM(TOTALCOST), 2) <= 500000
)
-- Joining both CTEs to the patients table
SELECT
    p.Id AS patient_id,
    p.RACE,
    p.ETHNICITY,
    p.GENDER,
    p.ZIP,
    p.INCOME,
    p.HEALTHCARE_EXPENSES,
    p.HEALTHCARE_COVERAGE,
    COALESCE(ec.total_encounters, 0) AS total_encounters,
    COALESCE(ec.total_encounter_costs, 0) AS total_encounter_costs,
    COALESCE(ec.encounter_payer_covered, 0) AS encounter_payer_covered,
    COALESCE(ec.encounter_payer_outofpocket, 0) AS  encounter_payer_outofpocket,
    COALESCE(ec.emergency_count, 0) AS emergency_count,
    COALESCE(ec.inpatient_count, 0) AS  inpatient_count,
    COALESCE(ec.wellness_count, 0) AS wellness_count,
    COALESCE(ec.ambulatory_count, 0) AS ambulatory_count,
    COALESCE(mc.prescription_count, 0) AS prescription_count,
    COALESCE(mc.total_prescription_cost, 0) AS total_prescription_cost,
    COALESCE(mc.prescription_payer_covered, 0) AS  prescription_payer_covered,
    COALESCE(ec.total_encounter_costs, 0)
        + COALESCE(mc.total_prescription_cost, 0) AS total_cost,
    COALESCE(ec.encounter_payer_covered, 0)
        + COALESCE(mc.prescription_payer_covered, 0) AS total_payer_covered
FROM patients p
LEFT JOIN encounter_costs ec
    ON p.Id = ec.PATIENT
LEFT JOIN medication_costs mc
    ON p.Id = mc.PATIENT
WHERE p.DEATHDATE IS NULL;





