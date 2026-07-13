
-- =====================================================================
-- 0. TABLE SETUP
-- =====================================================================
-- Schema for the cleaned deals table (key columns shown).

DROP TABLE IF EXISTS deals CASCADE;

CREATE TABLE deals (
    deal_id                  TEXT,
    created_date             DATE,
    close_date               DATE,
    fiscal_year              TEXT,
    quarter                  TEXT,
    month                    TEXT,
    sales_rep                TEXT,
    manager                  TEXT,
    region                   TEXT,
    city                     TEXT,
    customer_name            TEXT,
    industry                 TEXT,
    customer_type            TEXT,
    is_new_customer          TEXT,
    product_name             TEXT,
    product_category         TEXT,
    deal_size_tier           TEXT,
    pipeline_stage           TEXT,
    win_probability_pct      INTEGER,
    deal_status              TEXT,
    contract_value_vnd       NUMERIC,
    discount_pct             NUMERIC,
    discount_amount_vnd      NUMERIC,
    net_revenue_vnd          NUMERIC,
    cost_of_sale_vnd         NUMERIC,
    gross_profit_vnd         NUMERIC,
    gross_margin_pct         NUMERIC,
    payment_terms            TEXT,
    payment_collected_vnd    NUMERIC,
    outstanding_balance_vnd  NUMERIC,
    sales_cycle_days         INTEGER,
    lead_source              TEXT,
    lost_reason              TEXT,
    forecast_category        TEXT,
    activities_count         INTEGER,
    last_activity_date       DATE,
    customer_satisfaction    NUMERIC,
    nps_score                INTEGER,
    contract_renewed         TEXT,
    upsell_opportunity       TEXT,
    next_follow_up_date      DATE,
    notes                    TEXT
);

-- Load the cleaned export (adjust the path to your environment):
COPY deals FROM '/tmp/sales_data_cleaned.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8', NULL 'NA');

-- =====================================================================
-- 1. OVERVIEW  —  "What happened?"
-- =====================================================================

-- 1.1 Headline KPIs: won revenue, win rate, avg deal value, avg cycle
SELECT
    ROUND(SUM(net_revenue_vnd) FILTER (WHERE deal_status = 'Won') / 1e9, 1)  AS won_revenue_bn,
    ROUND(
        COUNT(*) FILTER (WHERE deal_status = 'Won')::numeric
        / NULLIF(COUNT(*) FILTER (WHERE deal_status IN ('Won','Lost')), 0), 3
    )                                                                        AS win_rate,
    ROUND(AVG(contract_value_vnd) FILTER (WHERE deal_status = 'Won') / 1e6)  AS avg_deal_value_mn,
    ROUND(AVG(sales_cycle_days)   FILTER (WHERE deal_status = 'Won'))        AS avg_sales_cycle_days
FROM deals;

-- 1.2 Win rate and won revenue by region
SELECT
    region,
    COUNT(*) FILTER (WHERE deal_status = 'Won')                              AS won_deals,
    ROUND(
        COUNT(*) FILTER (WHERE deal_status = 'Won')::numeric
        / NULLIF(COUNT(*) FILTER (WHERE deal_status IN ('Won','Lost')), 0), 3
    )                                                                        AS win_rate,
    ROUND(SUM(net_revenue_vnd) FILTER (WHERE deal_status = 'Won') / 1e9, 1)  AS won_revenue_bn
FROM deals
GROUP BY region
ORDER BY won_revenue_bn DESC;

-- 1.3 Won revenue by product category
SELECT
    product_category,
    ROUND(SUM(net_revenue_vnd) FILTER (WHERE deal_status = 'Won') / 1e9, 1)  AS won_revenue_bn
FROM deals
GROUP BY product_category
ORDER BY won_revenue_bn DESC;

-- 1.4 Pipeline funnel: deal count by stage
SELECT
    pipeline_stage,
    COUNT(*) AS deal_count
FROM deals
GROUP BY pipeline_stage
ORDER BY deal_count DESC;


-- =====================================================================
-- 2. LOSS ANALYSIS  —  "Why do we win or lose?"
-- =====================================================================

-- 2.1 Loss reasons ranked by frequency (feeds the Pareto)
SELECT
    lost_reason,
    COUNT(*) AS lost_deals
FROM deals
WHERE deal_status = 'Lost'
GROUP BY lost_reason
ORDER BY lost_deals DESC;

-- 2.2 Does discounting improve win rate? (banded)
SELECT
    CASE
        WHEN discount_pct <  5 THEN '0-5%'
        WHEN discount_pct < 10 THEN '5-10%'
        WHEN discount_pct < 15 THEN '10-15%'
        ELSE '15-20%'
    END AS discount_band,
    ROUND(
        COUNT(*) FILTER (WHERE deal_status = 'Won')::numeric
        / NULLIF(COUNT(*) FILTER (WHERE deal_status IN ('Won','Lost')), 0), 3
    ) AS win_rate,
    COUNT(*) FILTER (WHERE deal_status IN ('Won','Lost')) AS closed_deals
FROM deals
GROUP BY discount_band
ORDER BY discount_band;

-- 2.3 Discount leakage and gross margin (won deals)
SELECT
    ROUND(SUM(discount_amount_vnd) FILTER (WHERE deal_status = 'Won') / 1e9, 2) AS discount_leakage_bn,
    ROUND(
        SUM(gross_profit_vnd) FILTER (WHERE deal_status = 'Won')
        / NULLIF(SUM(net_revenue_vnd) FILTER (WHERE deal_status = 'Won'), 0), 3
    ) AS gross_margin
FROM deals;

-- 2.4 Rep performance: win rate vs sales cycle (min 5 closed deals)
SELECT
    sales_rep,
    COUNT(*) FILTER (WHERE deal_status IN ('Won','Lost'))                    AS closed_deals,
    ROUND(
        COUNT(*) FILTER (WHERE deal_status = 'Won')::numeric
        / NULLIF(COUNT(*) FILTER (WHERE deal_status IN ('Won','Lost')), 0), 3
    )                                                                        AS win_rate,
    ROUND(AVG(sales_cycle_days) FILTER (WHERE deal_status = 'Won'))          AS avg_cycle_days
FROM deals
GROUP BY sales_rep
HAVING COUNT(*) FILTER (WHERE deal_status IN ('Won','Lost')) >= 5
ORDER BY win_rate DESC;


-- =====================================================================
-- 3. PREDICTIVE ANALYSIS  —  "What's next?"
-- =====================================================================

-- 3.1 Open vs weighted pipeline (headline)
SELECT
    ROUND(SUM(contract_value_vnd) / 1e9, 1)                                  AS open_pipeline_bn,
    ROUND(SUM(contract_value_vnd * win_probability_pct / 100.0) / 1e9, 1)    AS weighted_pipeline_bn,
    ROUND(AVG(win_probability_pct))                                          AS avg_win_prob
FROM deals
WHERE deal_status = 'Open';

-- 3.2 Open vs weighted pipeline by stage
SELECT
    pipeline_stage,
    ROUND(SUM(contract_value_vnd) / 1e9, 1)                                  AS open_value_bn,
    ROUND(SUM(contract_value_vnd * win_probability_pct / 100.0) / 1e9, 1)    AS weighted_value_bn
FROM deals
WHERE deal_status = 'Open'
GROUP BY pipeline_stage
ORDER BY open_value_bn DESC;

-- 3.3 Pipeline concentration: region x deal-size tier
SELECT
    region,
    ROUND(SUM(contract_value_vnd) FILTER (WHERE deal_size_tier = 'Enterprise')  / 1e9, 1) AS enterprise_bn,
    ROUND(SUM(contract_value_vnd) FILTER (WHERE deal_size_tier = 'Mid-Market') / 1e9, 1) AS mid_market_bn,
    ROUND(SUM(contract_value_vnd) FILTER (WHERE deal_size_tier = 'SMB')        / 1e9, 1) AS smb_bn
FROM deals
WHERE deal_status = 'Open'
GROUP BY region
ORDER BY enterprise_bn DESC;
