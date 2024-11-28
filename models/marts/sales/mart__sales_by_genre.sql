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
    FROM {{ ref("fct_game_sales") }}  -- Asegúrate de que esta tabla existe y se referencia correctamente
)

SELECT
    genre,
    COUNT(DISTINCT purchase_id) AS total_sales_count,  -- Total de ventas (transacciones)
    SUM(quantity_purchased) AS total_quantity_sold,    -- Total de unidades vendidas
    SUM(price * quantity_purchased) AS total_revenue,  -- Ingresos totales
    AVG(user_rating) AS average_user_rating            -- Promedio de calificación de usuarios
FROM sales
GROUP BY genre

