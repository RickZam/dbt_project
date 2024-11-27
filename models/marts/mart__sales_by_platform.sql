WITH sales AS (
    SELECT
        purchase_id,
        purchase_date,
        quantity_purchased,
        price,
        platform,
        game_title,
        user_id,
        user_rating,
        load_date_utc
    FROM {{ ref('fct_game_sales') }} f
)

SELECT
    s.platform,
    COUNT(DISTINCT s.purchase_id) AS total_sales_count,  -- Total de ventas
    SUM(s.quantity_purchased) AS total_quantity_sold,   -- Total de unidades vendidas
    SUM(s.price * s.quantity_purchased) AS total_revenue, -- Ingresos totales
    AVG(s.user_rating) AS average_user_rating           -- Promedio de calificación de usuarios
FROM sales s
GROUP BY s.platform