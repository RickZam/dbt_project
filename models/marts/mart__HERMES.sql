{{ config(
    materialized='incremental',
    unique_key='purchase_id'
) }}

with
    -- Hechos: Tabla fct_game_sales
    fct_sales as (
        select
            purchase_id,
            purchase_date,
            quantity_purchased,
            price,
            game_id,
            user_id,
            platform_id,
            user_rating,
            shop_rating,
            user_review_text,
            platform as purchase_platform,
            load_date_utc
        from {{ ref("fct_game_sales") }}
    ),

    -- Dimensión de Usuarios
    dim_users as (
        select 
            user_id, 
            first_name, 
            last_name, 
            postal_code, 
            state, 
            country
        from {{ ref("dim_users") }}
    ),

    -- Dimensión de Plataformas
    dim_platform as (
        select 
            platform_id, 
            platform_name, 
            company_name, 
            country
        from {{ ref("dim_platform") }}
    ),

    -- Dimensión de Juegos
    dim_games as (
        select
            game_id,
            game_title,
            genre,
            platform,
            price,
            release_year,
            age_group_targeted,
            game_length_hours,
            multiplayer,
            min_number_of_players,
            requires_special_device,
            s_soundtrack_quality,
            s_graphics_quality,
            s_story_quality,
            shop_rating,
            shop_review_text
        from {{ ref("dim_game") }}
    ),



    -- Dimensión de Fecha (ajustada para crear todas las columnas necesarias)
    dim_date as (
        select 
            date,
            year,
            month,
            month_name,
            year_month_id,
            previous_day,
            year_week_day,
            week,
            day_name,
            week_of_month,
            day_of_year,
            season
        from {{ ref("dim_date") }}
    )

select
    -- Datos de la tabla de hechos
    s.purchase_id,
    s.purchase_date,
    s.quantity_purchased,
    s.price,
    s.game_id,
    g.game_title,
    g.genre,
    g.platform,
    s.platform_id,
    s.user_id,
    s.user_rating,
    s.shop_rating,
    s.user_review_text,
    s.purchase_platform,
    s.load_date_utc,

    -- Datos de las dimensiones
    u.first_name,
    u.last_name,
    u.postal_code,
    u.state as user_state,
    u.country as user_country,

    p.platform_name,
    p.company_name as platform_company_name,
    p.country as platform_country,

    g.release_year,
    g.age_group_targeted,
    g.game_length_hours,
    g.multiplayer,
    g.min_number_of_players,
    g.requires_special_device,
    g.s_soundtrack_quality,
    g.s_graphics_quality,
    g.s_story_quality,
    g.shop_review_text,

    -- Datos de la dimensión de fecha (ajustado)
    d.date,
    d.year,
    d.month,
    d.month_name,
    d.year_month_id,
    d.previous_day,
    d.year_week_day,
    d.week,
    d.day_name,
    d.week_of_month,
    d.day_of_year,
    d.season

from fct_sales s

-- Uniones con las dimensiones
left join dim_users u on s.user_id = u.user_id
left join dim_platform p on s.platform_id = p.platform_id
left join dim_games g on s.game_id = g.game_id
left join dim_date d on s.purchase_date = d.date 

{% if is_incremental() %}

  where load_date_utc > (select max(load_date_utc) from {{ this }})

{% endif %}
