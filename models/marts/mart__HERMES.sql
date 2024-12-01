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
        {{ dbt_utils.date_spine(
            datepart="day",
            start_date="cast('2000-01-01' as date)",
            end_date="cast('2025-01-01' as date)"
        ) }}
    ),

    -- Subconsulta que calcula las columnas adicionales para la dimensión de fecha
    dim_date_with_calculations as (
        select 
            date_day,
            year(date_day) as year,
            month(date_day) as month,
            to_char(date_day, 'Month') as month_name,  -- Nombre completo del mes
            year(date_day) * 100 + month(date_day) as year_month_id,  -- Identificador único Año-Mes
            date_day - interval '1 day' as previous_day,  -- Día anterior
            year(date_day) || '-' || lpad(week(date_day)::text, 2, '0') as year_week_day,  -- Año-Semana
            week(date_day) as week,  -- Número de semana
            case 
                when extract(dow from date_day) = 0 then 'Sunday'
                when extract(dow from date_day) = 1 then 'Monday'
                when extract(dow from date_day) = 2 then 'Tuesday'
                when extract(dow from date_day) = 3 then 'Wednesday'
                when extract(dow from date_day) = 4 then 'Thursday'
                when extract(dow from date_day) = 5 then 'Friday'
                when extract(dow from date_day) = 6 then 'Saturday'
            end as day_name,  -- Nombre del día de la semana
            case 
                when extract(day from date_day) between 1 and 7 then '1st Week'
                when extract(day from date_day) between 8 and 14 then '2nd Week'
                when extract(day from date_day) between 15 and 21 then '3rd Week'
                when extract(day from date_day) between 22 and 28 then '4th Week'
                else '5th Week'
            end as week_of_month,  -- Semana del mes
            extract(doy from date_day) as day_of_year,  -- Día del año
            case 
                when month(date_day) in (12, 1, 2) then 'Winter'
                when month(date_day) in (3, 4, 5) then 'Spring'
                when month(date_day) in (6, 7, 8) then 'Summer'
                when month(date_day) in (9, 10, 11) then 'Autumn'
            end as season
        from dim_date
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
    d.date_day as date,  -- Asegúrate de usar el nombre correcto aquí
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
left join dim_date_with_calculations d on s.purchase_date = d.date_day  -- Ajusta según el nombre correcto

{% if is_incremental() %}

  -- Solo seleccionamos los registros nuevos o actualizados
  where s.purchase_id > (select max(purchase_id) from {{ this }})

{% endif %}
