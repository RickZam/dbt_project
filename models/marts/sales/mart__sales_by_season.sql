WITH sales_by_season AS (
    SELECT
        dd.season,
        COUNT(DISTINCT f.purchase_id) AS total_sales_count,
        SUM(f.quantity_purchased) AS total_quantity_sold,
        SUM(f.price * f.quantity_purchased) AS total_revenue,
        AVG(f.user_rating) AS average_user_rating
    FROM {{ ref("fct_game_sales") }} f
    LEFT JOIN {{ ref("dim_date") }} dd ON f.purchase_date = dd.date
    GROUP BY dd.season
)
SELECT
    season,
    total_sales_count,
    total_quantity_sold,
    total_revenue,
    average_user_rating
FROM sales_by_season
ORDER BY total_revenue DESC