
with
    sales as (
        select
            f.purchase_id,
            f.purchase_date,
            f.quantity_purchased,
            f.price,
            f.platform,
            f.game_title,
            f.user_id,
            f.user_rating,
            f.load_date_utc
        from {{ ref("fct_game_sales") }} f
    )

select
    s.platform,
    count(distinct s.purchase_id) as total_sales_count,
    sum(s.quantity_purchased) as total_quantity_sold,
    sum(s.price * s.quantity_purchased) as total_revenue,
    avg(s.user_rating) as average_user_rating
from sales s
group by s.platform
ORDER BY total_revenue DESC
