WITH sales_by_user_region AS (
    SELECT
        u.state,
        u.country,
        COUNT(DISTINCT f.purchase_id) AS total_sales_count,
        SUM(f.quantity_purchased) AS total_quantity_sold,
        SUM(f.price * f.quantity_purchased) AS total_revenue,
        AVG(f.user_rating) AS average_user_rating
    FROM {{ ref("fct_game_sales") }} f
    LEFT JOIN {{ ref("dim_users") }} u ON f.user_id = u.user_id
    GROUP BY u.state, u.country
)
SELECT
    state,
    country,
    total_sales_count,
    total_quantity_sold,
    total_revenue,
    average_user_rating
FROM sales_by_user_region
ORDER BY total_revenue DESC