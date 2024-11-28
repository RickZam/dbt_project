WITH top_game_sales AS (
    -- Primero obtenemos el juego más vendido en los últimos 5 años
    SELECT
        f.game_id,
        g.game_title,
        SUM(f.quantity_purchased) AS total_quantity_sold
    FROM {{ ref("fct_game_sales") }} f
    JOIN {{ ref("dim_game") }} g
        ON f.game_id = g.game_id
    WHERE f.purchase_date >= DATEADD(year, -5, CURRENT_DATE)  -- Últimos 5 años
    GROUP BY f.game_id, g.game_title
    ORDER BY total_quantity_sold DESC
    LIMIT 1
)

SELECT
    f.purchase_id,
    f.purchase_date,
    f.quantity_purchased,
    f.price,
    f.game_id,
    g.game_title,
    f.user_id,
    f.user_rating,
    f.user_review_text,  -- Comentarios del usuario
    f.purchase_platform, 
    f.load_date_utc
FROM {{ ref("fct_game_sales") }} f
JOIN {{ ref("dim_game") }} g
    ON f.game_id = g.game_id
JOIN top_game_sales tgs
    ON f.game_id = tgs.game_id  -- Solo comentarios para el juego más vendido
WHERE f.purchase_date >= DATEADD(year, -5, CURRENT_DATE)  -- Últimos 5 años
ORDER BY f.purchase_date DESC