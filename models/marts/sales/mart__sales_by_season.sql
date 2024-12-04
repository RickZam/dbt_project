{{ config(
    materialized='incremental',
    unique_key='purchase_id'
) }}

with
    sales_by_season as (
        select
            dd.season,
            count(distinct f.purchase_id) as total_sales_count,
            sum(f.quantity_purchased) as total_quantity_sold,
            sum(f.price * f.quantity_purchased) as total_revenue,
            avg(f.user_rating) as average_user_rating
        from {{ ref("fct_game_sales") }} f
        left join {{ ref("dim_date") }} dd on f.purchase_date = dd.date
        group by dd.season
    )
select
    season, total_sales_count, 
    total_quantity_sold, 
    total_revenue, 
    average_user_rating
from sales_by_season
order by total_revenue desc

{% if is_incremental() %}

  where load_date_utc > (select max(load_date_utc) from {{ this }})

{% endif %}