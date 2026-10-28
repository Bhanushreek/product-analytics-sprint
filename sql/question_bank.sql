-- Question: What event types are recorded, and how many events and sessions have each type?
SELECT
  event_type,
  COUNT(*) AS events,
  COUNT(DISTINCT session_id) AS sessions
FROM `bigquery-public-data.thelook_ecommerce.events`
GROUP BY event_type
ORDER BY events DESC;

-- Finding: The dataset has six event types. Product is most common (841,146 events; 680,424 sessions), and home is least common (87,393 events).


-- Question: What is the date range of events in the dataset?
SELECT
  MIN(created_at) AS first_event,
  MAX(created_at) AS last_event
FROM `bigquery-public-data.thelook_ecommerce.events`;

-- Finding: Event timestamps span 2019-01-02 00:25:00 UTC to 2026-10-30 23:51:30.884743 UTC; the latest timestamp is future-dated relative to the query date.


-- Question: How many sessions view a product, add it to cart, and purchase?
WITH session_steps AS (
  SELECT
    session_id,
    MAX(IF(LOWER(event_type) = 'product', 1, 0)) AS viewed_product,
    MAX(IF(LOWER(event_type) = 'cart', 1, 0)) AS added_to_cart,
    MAX(IF(LOWER(event_type) = 'purchase', 1, 0)) AS purchased
  FROM `bigquery-public-data.thelook_ecommerce.events`
  GROUP BY session_id
),
funnel AS (
  SELECT
    SUM(viewed_product) AS product_view_sessions,
    SUM(IF(viewed_product = 1 AND added_to_cart = 1, 1, 0)) AS cart_sessions,
    SUM(IF(viewed_product = 1 AND added_to_cart = 1 AND purchased = 1, 1, 0)) AS purchase_sessions
  FROM session_steps
)
SELECT
  product_view_sessions,
  cart_sessions,
  purchase_sessions,
  ROUND(SAFE_DIVIDE(cart_sessions, product_view_sessions) * 100, 1) AS view_to_cart_pct,
  ROUND(SAFE_DIVIDE(purchase_sessions, cart_sessions) * 100, 1) AS cart_to_purchase_pct,
  ROUND(SAFE_DIVIDE(purchase_sessions, product_view_sessions) * 100, 1) AS overall_pct
FROM funnel;

-- Finding: 680,424 sessions viewed a product, 430,642 added to cart, and 180,424 purchased. The largest drop was cart to purchase, where 58.1% of cart sessions did not purchase.


-- Question: How does the product-view-to-purchase funnel compare by traffic source?
WITH session_steps AS (
  SELECT
    session_id,
    ANY_VALUE(traffic_source) AS traffic_source,
    MAX(IF(LOWER(event_type) = 'product', 1, 0)) AS viewed_product,
    MAX(IF(LOWER(event_type) = 'cart', 1, 0)) AS added_to_cart,
    MAX(IF(LOWER(event_type) = 'purchase', 1, 0)) AS purchased
  FROM `bigquery-public-data.thelook_ecommerce.events`
  GROUP BY session_id
)
SELECT
  traffic_source,
  SUM(viewed_product) AS product_view_sessions,
  SUM(IF(viewed_product = 1 AND added_to_cart = 1, 1, 0)) AS cart_sessions,
  SUM(IF(viewed_product = 1 AND added_to_cart = 1 AND purchased = 1, 1, 0)) AS purchase_sessions,
  ROUND(SAFE_DIVIDE(SUM(IF(viewed_product = 1 AND added_to_cart = 1, 1, 0)), SUM(viewed_product)) * 100, 1) AS view_to_cart_pct,
  ROUND(SAFE_DIVIDE(SUM(IF(viewed_product = 1 AND added_to_cart = 1 AND purchased = 1, 1, 0)), SUM(viewed_product)) * 100, 1) AS overall_pct
FROM session_steps
GROUP BY traffic_source
ORDER BY product_view_sessions DESC;

-- Finding: Facebook and Organic tied for the highest product-view-to-purchase rate at 26.6%; YouTube was lowest at 26.4%, a 0.2 percentage-point gap. This small difference is descriptive, not proof of a meaningful performance difference.


-- Question: How does the product-view-to-purchase funnel compare by browser?
WITH session_steps AS (
  SELECT
    session_id,
    ANY_VALUE(browser) AS browser,
    MAX(IF(LOWER(event_type) = 'product', 1, 0)) AS viewed_product,
    MAX(IF(LOWER(event_type) = 'cart', 1, 0)) AS added_to_cart,
    MAX(IF(LOWER(event_type) = 'purchase', 1, 0)) AS purchased
  FROM `bigquery-public-data.thelook_ecommerce.events`
  GROUP BY session_id
)
SELECT
  browser,
  SUM(viewed_product) AS product_view_sessions,
  SUM(IF(viewed_product = 1 AND added_to_cart = 1, 1, 0)) AS cart_sessions,
  SUM(IF(viewed_product = 1 AND added_to_cart = 1 AND purchased = 1, 1, 0)) AS purchase_sessions,
  ROUND(SAFE_DIVIDE(SUM(IF(viewed_product = 1 AND added_to_cart = 1, 1, 0)), SUM(viewed_product)) * 100, 1) AS view_to_cart_pct,
  ROUND(SAFE_DIVIDE(SUM(IF(viewed_product = 1 AND added_to_cart = 1 AND purchased = 1, 1, 0)), SUM(viewed_product)) * 100, 1) AS overall_pct
FROM session_steps
GROUP BY browser
ORDER BY product_view_sessions DESC;

-- Finding: Other had the highest product-view-to-purchase rate at 26.7%, while IE was lowest at 26.4%, a 0.3 percentage-point gap. “Other” combines multiple browsers, so the comparison is descriptive.


-- Question: How does product-view-to-purchase conversion change by month?
WITH session_steps AS (
  SELECT
    session_id,
    DATE_TRUNC(DATE(MIN(created_at)), MONTH) AS session_month,
    MAX(IF(LOWER(event_type) = 'product', 1, 0)) AS viewed_product,
    MAX(IF(LOWER(event_type) = 'cart', 1, 0)) AS added_to_cart,
    MAX(IF(LOWER(event_type) = 'purchase', 1, 0)) AS purchased
  FROM `bigquery-public-data.thelook_ecommerce.events`
  GROUP BY session_id
)
SELECT
  session_month,
  SUM(viewed_product) AS product_view_sessions,
  SUM(IF(viewed_product = 1 AND added_to_cart = 1 AND purchased = 1, 1, 0)) AS purchase_sessions,
  ROUND(
    SAFE_DIVIDE(
      SUM(IF(viewed_product = 1 AND added_to_cart = 1 AND purchased = 1, 1, 0)),
      SUM(viewed_product)
    ) * 100,
    1
  ) AS overall_pct
FROM session_steps
GROUP BY session_month
ORDER BY session_month;

-- Finding: Product-view-to-purchase conversion rose overall from 0.1% in January 2019 to 61.1% in September 2026, with month-to-month fluctuations. October 2026 is excluded because it is the current, incomplete month.


-- Question: What is the cart abandonment rate by traffic source?
WITH session_steps AS (
  SELECT
    session_id,
    ANY_VALUE(traffic_source) AS traffic_source,
    MAX(IF(LOWER(event_type) = 'cart', 1, 0)) AS added_to_cart,
    MAX(IF(LOWER(event_type) = 'purchase', 1, 0)) AS purchased
  FROM `bigquery-public-data.thelook_ecommerce.events`
  GROUP BY session_id
)
SELECT
  traffic_source,
  SUM(added_to_cart) AS cart_sessions,
  SUM(IF(added_to_cart = 1 AND purchased = 0, 1, 0)) AS abandoned_sessions,
  ROUND(
    SAFE_DIVIDE(
      SUM(IF(added_to_cart = 1 AND purchased = 0, 1, 0)),
      SUM(added_to_cart)
    ) * 100,
    1
  ) AS abandonment_pct
FROM session_steps
GROUP BY traffic_source
ORDER BY abandonment_pct DESC;

-- Finding: YouTube had the highest cart abandonment at 58.3%, and Organic the lowest at 57.9%, a 0.4 percentage-point gap. The rates are similar and descriptive, not evidence that traffic source causes abandonment.


-- Question: How does buyer retention change by cohort month and months since the first order?
WITH orders_clean AS (
  SELECT
    user_id,
    DATE_TRUNC(DATE(created_at), MONTH) AS order_month
  FROM `bigquery-public-data.thelook_ecommerce.orders`
  WHERE status != 'Cancelled'
),
first_order AS (
  SELECT
    user_id,
    MIN(order_month) AS cohort_month
  FROM orders_clean
  GROUP BY user_id
),
activity AS (
  SELECT DISTINCT
    o.user_id,
    f.cohort_month,
    DATE_DIFF(o.order_month, f.cohort_month, MONTH) AS months_since_first
  FROM orders_clean AS o
  JOIN first_order AS f
    ON o.user_id = f.user_id
),
cohort_size AS (
  SELECT
    cohort_month,
    COUNT(DISTINCT user_id) AS cohort_users
  FROM first_order
  GROUP BY cohort_month
)
SELECT
  a.cohort_month,
  c.cohort_users,
  a.months_since_first,
  COUNT(DISTINCT a.user_id) AS active_users,
  ROUND(
    SAFE_DIVIDE(COUNT(DISTINCT a.user_id), c.cohort_users) * 100,
    1
  ) AS retention_pct
FROM activity AS a
JOIN cohort_size AS c
  ON a.cohort_month = c.cohort_month
WHERE a.months_since_first BETWEEN 0 AND 6
  AND a.cohort_month <= DATE_SUB(
    DATE_TRUNC(CURRENT_DATE(), MONTH),
    INTERVAL 6 MONTH
  )
GROUP BY
  a.cohort_month,
  c.cohort_users,
  a.months_since_first
ORDER BY
  a.cohort_month,
  a.months_since_first;

-- Finding: Unweighted average cohort retention was about 1.5% at month 1, 1.6% at month 3, and 1.6% at month 6; it stayed nearly flat from month 1 to month 6.


-- Question: What share of buyers placed at least two non-cancelled orders?
SELECT
  COUNT(*) AS buyers,
  COUNTIF(order_count >= 2) AS repeat_buyers,
  ROUND(
    SAFE_DIVIDE(COUNTIF(order_count >= 2), COUNT(*)) * 100,
    1
  ) AS repeat_rate_pct
FROM (
  SELECT
    user_id,
    COUNT(*) AS order_count
  FROM `bigquery-public-data.thelook_ecommerce.orders`
  WHERE status != 'Cancelled'
  GROUP BY user_id
);

-- Finding: 24,111 of 71,738 buyers placed at least two non-cancelled orders, for an overall repeat-purchase rate of 33.6%.


-- Question: How does repeat-purchase rate compare by user traffic source?
SELECT
  u.traffic_source,
  COUNT(*) AS buyers,
  COUNTIF(o.order_count >= 2) AS repeat_buyers,
  ROUND(
    SAFE_DIVIDE(COUNTIF(o.order_count >= 2), COUNT(*)) * 100,
    1
  ) AS repeat_rate_pct
FROM (
  SELECT
    user_id,
    COUNT(*) AS order_count
  FROM `bigquery-public-data.thelook_ecommerce.orders`
  WHERE status != 'Cancelled'
  GROUP BY user_id
) AS o
JOIN `bigquery-public-data.thelook_ecommerce.users` AS u
  ON u.id = o.user_id
GROUP BY u.traffic_source
ORDER BY repeat_rate_pct DESC;

-- Finding: Display had the highest repeat-purchase rate at 34.7%, while Email had the lowest at 32.1%, a 2.6 percentage-point gap. These are user-table traffic-source categories.


-- Question: Among repeat buyers, what is the median time between their first and second non-cancelled orders?
WITH ranked AS (
  SELECT
    user_id,
    created_at,
    ROW_NUMBER() OVER (
      PARTITION BY user_id
      ORDER BY created_at
    ) AS rn
  FROM `bigquery-public-data.thelook_ecommerce.orders`
  WHERE status != 'Cancelled'
),
gaps AS (
  SELECT
    a.user_id,
    TIMESTAMP_DIFF(b.created_at, a.created_at, DAY) AS days_to_second
  FROM ranked AS a
  JOIN ranked AS b
    ON a.user_id = b.user_id
   AND a.rn = 1
   AND b.rn = 2
)
SELECT
  APPROX_QUANTILES(days_to_second, 2)[OFFSET(1)] AS median_days_to_second_order
FROM gaps;

-- Finding: Among buyers with at least two non-cancelled orders, the approximate median time from first to second order was 257 days.


