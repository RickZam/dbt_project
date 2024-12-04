
with
    platform_sales as (
        select
            p.platform_id,
            p.platform_name,
            p.company_name,
            sum(d.quantity_purchased) as total_quantity_sold,
            sum(d.price * d.quantity_purchased) as total_revenue
        from {{ ref("fct_game_sales") }} d
        join {{ ref("dim_platform") }} p on d.platform_id = p.platform_id
        group by p.platform_id, p.platform_name, p.company_name
    ),

    country_sales as (
        select
            p.country,
            p.company_name,
            sum(d.quantity_purchased) as total_quantity_sold,
            sum(d.price * d.quantity_purchased) as total_revenue
        from {{ ref("fct_game_sales") }} d
        join {{ ref("dim_platform") }} p on d.platform_id = p.platform_id
        group by p.country, p.company_name
    )

select
    ps.platform_name,
    ps.total_quantity_sold as platform_quantity_sold,
    ps.total_revenue as platform_revenue,
    cs.country,
    cs.total_quantity_sold as country_quantity_sold,
    cs.total_revenue as country_revenue
from platform_sales ps
join country_sales cs on ps.company_name = cs.company_name
order by ps.total_quantity_sold desc, cs.total_quantity_sold desc

