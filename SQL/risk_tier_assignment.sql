WITH cost_ranked AS (
    SELECT
        patient_id,
        total_cost,
        total_encounter_costs,
        total_prescription_cost,
        emergency_count,
        inpatient_count,
        wellness_count,
        ambulatory_count,
        total_encounters,
        prescription_count,
        RACE,
        GENDER,
        INCOME,
        ZIP,
        NTILE(4) OVER (ORDER BY total_cost DESC) AS cost_quartile
    FROM member_cost_summary
)
SELECT
    patient_id,
    total_cost,
    total_encounter_costs,
    total_prescription_cost,
    emergency_count,
    inpatient_count,
    wellness_count,
    ambulatory_count,
    total_encounters,
    prescription_count,
    RACE,
    GENDER,
    INCOME,
    ZIP,
    cost_quartile,
    CASE cost_quartile
        WHEN 1 THEN 'TIER 1 - High Risk'
        WHEN 2 THEN 'TIER 2 - Elevated Risk'
        WHEN 3 THEN 'TIER 3 - Moderate Risk'
        WHEN 4 THEN 'Tier 4 - Low Risk'
    END AS risk_tier
FROM cost_ranked
ORDER BY total_cost DESC;

SELECT
    risk_tier,
    COUNT(*) AS member_count,
    ROUND(MIN(total_cost), 2) AS min_cost,
    ROUND(MAX(total_cost), 2) AS max_cost,
    ROUND(AVG(total_cost), 2) AS avg_cost,
    ROUND(SUM(total_cost), 2) AS total_cost
FROM (
         WITH cost_ranked AS (
             SELECT
                 patient_id,
                 total_cost,
                 total_encounter_costs,
                 total_prescription_cost,
                 emergency_count,
                 inpatient_count,
                 wellness_count,
                 ambulatory_count,
                 total_encounters,
                 prescription_count,
                 RACE,
                 GENDER,
                 INCOME,
                 ZIP,
                 NTILE(4) OVER (ORDER BY total_cost DESC) AS cost_quartile
             FROM member_cost_summary
         )
         SELECT
             patient_id,
             total_cost,
             total_encounter_costs,
             total_prescription_cost,
             emergency_count,
             inpatient_count,
             wellness_count,
             ambulatory_count,
             total_encounters,
             prescription_count,
             RACE,
             GENDER,
             INCOME,
             ZIP,
             cost_quartile,
             CASE cost_quartile
                 WHEN 1 THEN 'TIER 1 - High Risk'
                 WHEN 2 THEN 'TIER 2 - Elevated Risk'
                 WHEN 3 THEN 'TIER 3 - Moderate Risk'
                 WHEN 4 THEN 'Tier 4 - Low Risk'
                 END AS risk_tier
         FROM cost_ranked
         ORDER BY total_cost DESC
) AS tiered
GROUP BY risk_tier
ORDER BY avg_cost DESC;


