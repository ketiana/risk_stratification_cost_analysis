WITH tiered AS (
    WITH cost_ranked AS (
        SELECT
            patient_id,
            total_cost,
            total_encounter_costs,
            total_prescription_cost,
            emergency_count,
            inpatient_count,
            wellness_count,
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
),
totals AS (
    SELECT SUM(total_cost) AS grand_total FROM tiered
)
SELECT
    t.risk_tier,
    COUNT(*) AS member_count_two,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS percent_of_members,
    ROUND(SUM(t.total_cost), 2) AS tier_total_cost,
    ROUND(SUM(t.total_cost) * 100.0 / tt.grand_total, 1) AS percent_of_total,
    ROUND(AVG(t.total_cost), 2) AS avg_cost_per_member
FROM tiered t
CROSS JOIN totals tt
GROUP BY t.risk_tier, tt.grand_total
ORDER BY avg_cost_per_member DESC;