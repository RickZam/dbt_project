
with
    sales_by_user_region as (
        select
            u.state,
            u.country,
            count(distinct f.purchase_id) as total_sales_count,
            sum(f.quantity_purchased) as total_quantity_sold,
            sum(f.price * f.quantity_purchased) as total_revenue,
            avg(f.user_rating) as average_user_rating
        from {{ ref("fct_game_sales") }} f
        left join {{ ref("dim_users") }} u on f.user_id = u.user_id
        group by u.state, u.country
    )
select
    state,
    country,
    total_sales_count,
    total_quantity_sold,
    total_revenue,
    average_user_rating
from sales_by_user_region
order by total_revenue desc
