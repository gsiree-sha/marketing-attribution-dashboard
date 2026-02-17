/* ============================================================
   Funnel Analysis: visit -> add_to_cart -> purchase
   Output:
   - counts by channel
   - conversion rates between steps
   - drop-off percentages
   Tableau-friendly.
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
funnel_counts AS (
  SELECT
    channel,
    COUNT(*) FILTER (WHERE event_type = 'visit')       AS visits,
    COUNT(*) FILTER (WHERE event_type = 'add_to_cart') AS add_to_cart,
    COUNT(*) FILTER (WHERE event_type = 'purchase')    AS purchases
  FROM events_clean
  GROUP BY 1
)

SELECT
  channel,
  visits,
  add_to_cart,
  purchases,

  -- step conversion rates
  CASE WHEN visits > 0 THEN add_to_cart::NUMERIC / visits ELSE 0 END AS visit_to_cart_rate,
  CASE WHEN add_to_cart > 0 THEN purchases::NUMERIC / add_to_cart ELSE 0 END AS cart_to_purchase_rate,
  CASE WHEN visits > 0 THEN purchases::NUMERIC / visits ELSE 0 END AS visit_to_purchase_rate,

  -- drop-offs
  CASE WHEN visits > 0 THEN (visits - add_to_cart)::NUMERIC / visits ELSE 0 END AS dropoff_after_visit_pct,
  CASE WHEN add_to_cart > 0 THEN (add_to_cart - purchases)::NUMERIC / add_to_cart ELSE 0 END AS dropoff_after_cart_pct

FROM funnel_counts
WHERE channel <> 'Other'
ORDER BY visits DESC;


/* ============================================================
   Optional: Funnel by date + channel (for trend visuals)
   ============================================================ */

WITH events_clean AS (
  SELECT
    DATE(timestamp) AS date,
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
    date,
    channel,
    COUNT(*) FILTER (WHERE event_type = 'visit')       AS visits,
    COUNT(*) FILTER (WHERE event_type = 'add_to_cart') AS add_to_cart,
    COUNT(*) FILTER (WHERE event_type = 'purchase')    AS purchases
  FROM events_clean
  GROUP BY 1,2
)

SELECT
  date,
  channel,
  visits,
  add_to_cart,
  purchases,
  CASE WHEN visits > 0 THEN add_to_cart::NUMERIC / visits ELSE 0 END AS visit_to_cart_rate,
  CASE WHEN add_to_cart > 0 THEN purchases::NUMERIC / add_to_cart ELSE 0 END AS cart_to_purchase_rate,
  CASE WHEN visits > 0 THEN purchases::NUMERIC / visits ELSE 0 END AS visit_to_purchase_rate
FROM daily_funnel
WHERE channel <> 'Other'
ORDER BY date, channel;
