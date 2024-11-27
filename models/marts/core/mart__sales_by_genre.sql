with
    sales as (
        select
            purchase_id,
            purchase_date,
            quantity_purchased,
            price,
            genre,
            game_title,
            user_id,
            user_rating,
            load_date_utc
        from {{ ref("fct_game_sales") }}
    )

select
    genre,
    count(distinct purchase_id) as total_sales_count,  -- Total de ventas (transacciones)
    sum(quantity_purchased) as total_quantity_sold,  -- Total de unidades vendidas
    sum(price * s.quantity_purchased) as total_revenue,  -- Ingresos totales
    avg(user_rating) as average_user_rating  -- Promedio de calificación de usuarios
from sales
group by genre
