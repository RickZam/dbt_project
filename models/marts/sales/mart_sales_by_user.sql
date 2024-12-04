

WITH sales AS (
    SELECT
        f.purchase_id,
        f.purchase_date,
        f.quantity_purchased,
        f.price,
        f.user_id,
        f.game_title,
        f.user_rating,
        f.load_date_utc
    FROM {{ ref('fct_game_sales') }} f
)

SELECT
    s.user_id,
    COUNT(DISTINCT s.purchase_id) AS total_sales_count,
    SUM(s.quantity_purchased) AS total_quantity_sold,
    SUM(s.price * s.quantity_purchased) AS total_revenue,
    ROUND(AVG(s.user_rating), 2) AS average_user_rating 
FROM sales s
GROUP BY s.user_id
ORDER BY total_revenue DESC

