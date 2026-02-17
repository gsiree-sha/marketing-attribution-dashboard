/* ============================================================
   Trend Analysis
   - Daily revenue by channel (last touch)
   - 7-day moving average
   - Week-over-week growth
   ============================================================ */

WITH events_clean AS (
  SELECT
    user_id,
    timestamp,
    CASE
      WHEN LOWER(source_medium) LIKE 'paid search%' THEN 'Paid Search'
      WHEN LOWER(source_medium) LIKE 'social%' THEN 'Social'
      WHEN LOWER(source_medium) LIKE 'email%' THEN 'Email'
      WHEN LOWER(source_medium) LIKE 'display%' THEN 'Display'
      WHEN LOWER(source_medium) LIKE 'organic%' THEN 'Organic'
      ELSE 'Other'
    END AS channel
  FROM web_events
),

-- Last touch attribution for revenue
last_touch_orders AS (
  SELECT
    DATE(c.conversion_time) AS date,
    c.revenue,
    e.channel
  FROM conversions c
  JOIN LATERAL (
    SELECT channel
    FROM events_clean we
    WHERE we.user_id = c.user_id
      AND we.timestamp <= c.conversion_time
    ORDER BY we.timestamp DESC
    LIMIT 1
  ) e ON TRUE
),

daily_revenue AS (
  SELECT
    date,
    channel,
    SUM(revenue) AS revenue
  FROM last_touch_orders
  GROUP BY 1,2
),

trend_base AS (
  SELECT
    date,
    channel,
    revenue,

    -- 7-day moving average
    AVG(revenue) OVER (
      PARTITION BY channel
      ORDER BY date
      ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS revenue_7d_ma

  FROM daily_revenue
),

weekly_rollup AS (
  SELECT
    DATE_TRUNC('week', date) AS week_start,
    channel,
    SUM(revenue) AS weekly_revenue
  FROM daily_revenue
  GROUP BY 1,2
),

weekly_growth AS (
  SELECT
    week_start,
    channel,
    weekly_revenue,
    LAG(weekly_revenue) OVER (
      PARTITION BY channel
      ORDER BY week_start
    ) AS prev_week_revenue
  FROM weekly_rollup
)

-- Final Output
SELECT
  t.date,
  t.channel,
  t.revenue,
  t.revenue_7d_ma,

  w.week_start,
  w.weekly_revenue,
  CASE
    WHEN w.prev_week_revenue > 0
    THEN (w.weekly_revenue - w.prev_week_revenue)::NUMERIC
         / w.prev_week_revenue
    ELSE NULL
  END AS week_over_week_growth_pct

FROM trend_base t
LEFT JOIN weekly_growth w
  ON DATE_TRUNC('week', t.date) = w.week_start
  AND t.channel = w.channel

ORDER BY t.date, t.channel;
