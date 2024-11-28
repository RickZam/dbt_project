WITH sales AS (
    SELECT
        f.purchase_id,
        f.purchase_date,
        f.quantity_purchased,
        f.price
    FROM {{ ref('fct_game_sales') }} f
),
sales_with_date AS (
    SELECT
        s.purchase_id,
        s.quantity_purchased,
        s.price,
        dd.date,
        dd.year,
        dd.month,
        dd.month_name,
        dd.season
    FROM sales s
    LEFT JOIN {{ ref('dim_date') }} dd
        ON s.purchase_date = dd.date
),
sales_by_month AS (
    SELECT
        year,
        month_name,
        SUM(quantity_purchased) AS total_quantity_sold,
        SUM(price * quantity_purchased) AS total_revenue
    FROM sales_with_date
    GROUP BY year, month_name
    ORDER BY year, month_name
)
SELECT
    'Monthly' AS granularity,
    year,
    month_name AS period,
    NULL AS season,
    total_quantity_sold,
    total_revenue
FROM sales_by_month
