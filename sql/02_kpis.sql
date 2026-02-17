/* ============================================================
   KPI Layer: Daily channel performance (Tableau-friendly)
   ============================================================ */

WITH events_clean AS (
  SELECT
    user_id,
    session_id,
    timestamp,
    event_type,
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
daily_funnel AS (
  SELECT
    DATE(timestamp) AS date,
    channel,
    COUNT(*) FILTER (WHERE event_type = 'visit')       AS visits,
    COUNT(*) FILTER (WHERE event_type = 'add_to_cart') AS add_to_cart,
    COUNT(*) FILTER (WHERE event_type = 'purchase')    AS purchases
  FROM events_clean
  GROUP BY 1, 2
),
last_touch_orders AS (
  SELECT
    c.order_id,
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
daily_revenue_by_channel AS (
  SELECT
    date,
    channel,
    SUM(revenue) AS revenue
  FROM last_touch_orders
  GROUP BY 1, 2
),
base AS (
  SELECT
    s.date,
    s.channel,
    SUM(s.spend)       AS spend,
    SUM(s.impressions) AS impressions,
    SUM(s.clicks)      AS clicks,
    COALESCE(f.visits, 0)       AS visits,
    COALESCE(f.add_to_cart, 0)  AS add_to_cart,
    COALESCE(f.purchases, 0)    AS purchases,
    COALESCE(r.revenue, 0)      AS revenue
  FROM campaign_spend s
  LEFT JOIN daily_funnel f
    ON f.date = s.date AND f.channel = s.channel
  LEFT JOIN daily_revenue_by_channel r
    ON r.date = s.date AND r.channel = s.channel
  GROUP BY 1,2,6,7,8,9
)

SELECT
  date,
  channel,
  spend,
  impressions,
  clicks,
  visits,
  add_to_cart,
  purchases,
  revenue,

  CASE WHEN impressions > 0 THEN clicks::NUMERIC / impressions ELSE 0 END AS ctr,
  CASE WHEN visits > 0 THEN purchases::NUMERIC / visits ELSE 0 END AS cvr,
  CASE WHEN purchases > 0 THEN spend / purchases ELSE NULL END AS cpa,
  CASE WHEN spend > 0 THEN revenue / spend ELSE NULL END AS roas
FROM base
ORDER BY 1,2;
