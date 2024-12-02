WITH sales AS (
    SELECT
        purchase_id,
        purchase_date,
        quantity_purchased,
        price,
        genre,
        game_title,
        user_id,
        user_rating,
        load_date_utc
    FROM {{ ref("fct_game_sales") }}
)

SELECT
    genre,
    COUNT(DISTINCT purchase_id) AS total_sales_count,
    SUM(quantity_purchased) AS total_quantity_sold,
    SUM(price * quantity_purchased) AS total_revenue,
    AVG(user_rating) AS average_user_rating
FROM sales
GROUP BY genre
ORDER BY total_revenue DESC

