-- =============================================================================
-- rfm_analysis.sql
-- Customer Segmentation using RFM (Recency · Frequency · Monetary) Analysis
-- =============================================================================
-- Compatible with: PostgreSQL 13+, MySQL 8+, SQLite 3.25+ (minor adjustments)
-- Assumes table: retail_transactions(order_id, customer_id, order_date, amount)
-- Snapshot date  (change as needed): '2024-12-31'
-- =============================================================================


-- ─────────────────────────────────────────────────────────────────────────────
-- STEP 1 ▸ Raw RFM Values per customer
-- ─────────────────────────────────────────────────────────────────────────────
WITH rfm_raw AS (
    SELECT
        customer_id,
        -- Recency  : days since last purchase (lower = better)
        DATEDIFF('2024-12-31', MAX(order_date))          AS recency_days,
        -- Frequency: total number of orders placed
        COUNT(DISTINCT order_id)                          AS frequency,
        -- Monetary : total spend in the period
        ROUND(SUM(amount), 2)                             AS monetary
    FROM retail_transactions
    WHERE order_date <= '2024-12-31'
    GROUP BY customer_id
),

-- ─────────────────────────────────────────────────────────────────────────────
-- STEP 2 ▸ Assign 1–5 scores using NTILE window functions
-- ─────────────────────────────────────────────────────────────────────────────
rfm_scores AS (
    SELECT
        customer_id,
        recency_days,
        frequency,
        monetary,

        -- Recency score: 5 = most recent (lowest days), 1 = least recent
        6 - NTILE(5) OVER (ORDER BY recency_days ASC)    AS r_score,

        -- Frequency score: 5 = highest order count
        NTILE(5) OVER (ORDER BY frequency ASC)           AS f_score,

        -- Monetary score: 5 = highest spend
        NTILE(5) OVER (ORDER BY monetary ASC)            AS m_score
    FROM rfm_raw
),

-- ─────────────────────────────────────────────────────────────────────────────
-- STEP 3 ▸ Composite RFM score and segment label
-- ─────────────────────────────────────────────────────────────────────────────
rfm_segmented AS (
    SELECT
        customer_id,
        recency_days,
        frequency,
        monetary,
        r_score,
        f_score,
        m_score,
        ROUND((r_score + f_score + m_score) / 3.0, 2)   AS avg_rfm_score,

        -- Three-cohort segmentation rule
        CASE
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
                THEN 'Champions'
            WHEN (r_score >= 3 AND f_score >= 3)
              OR (r_score >= 4 AND m_score >= 3)
                THEN 'Loyal'
            ELSE 'At-Risk'
        END                                              AS segment
    FROM rfm_scores
)

-- ─────────────────────────────────────────────────────────────────────────────
-- STEP 4 ▸ Final output (one row per customer)
-- ─────────────────────────────────────────────────────────────────────────────
SELECT
    customer_id,
    recency_days,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    avg_rfm_score,
    segment
FROM rfm_segmented
ORDER BY avg_rfm_score DESC, monetary DESC;


-- =============================================================================
-- SEGMENT SUMMARY VIEW  (run after the main query)
-- =============================================================================
-- SELECT
--     segment,
--     COUNT(*)                       AS customer_count,
--     ROUND(AVG(recency_days), 1)    AS avg_recency,
--     ROUND(AVG(frequency),    1)    AS avg_frequency,
--     ROUND(AVG(monetary),     2)    AS avg_monetary,
--     ROUND(SUM(monetary),     2)    AS total_revenue,
--     ROUND(SUM(monetary) * 100.0 / SUM(SUM(monetary)) OVER (), 2) AS revenue_pct
-- FROM rfm_segmented
-- GROUP BY segment
-- ORDER BY avg_rfm_score DESC;
