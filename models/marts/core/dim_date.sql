with
    dim_date as (
        {{
            dbt_utils.date_spine(
                datepart="day",
                start_date="cast('2000-01-01' as date)",
                end_date="cast('2025-01-01' as date)",
            )
        }}
    )
select
    date_day as date,  -- Fecha como clave primaria
    year(date_day) * 10000 + month(date_day) * 100 + day(date_day) as id_date,  -- Identificador único de la fecha (YYYYMMDD)
    year(date_day) as year,  -- Año de la fecha
    month(date_day) as month,  -- Mes de la fecha
    monthname(date_day) as month_name,  -- Nombre completo del mes (por ejemplo, "Enero")
    year(date_day) * 100 + month(date_day) as year_month_id,  -- Identificador único Año-Mes (YYYYMM)
    date_day - 1 as previous_day,  -- Día anterior
    year(date_day) || weekiso(date_day) || dayofweek(date_day) as year_week_day,  -- Identificador único Año-Semana-Día
    weekiso(date_day) as week,  -- Número de semana ISO
    case
        when date_part('DOW', date_day) = 0
        then 'Sunday'  -- Día de la semana (Domingo=0, Sábado=6)
        when date_part('DOW', date_day) = 1
        then 'Monday'
        when date_part('DOW', date_day) = 2
        then 'Tuesday'
        when date_part('DOW', date_day) = 3
        then 'Wednesday'
        when date_part('DOW', date_day) = 4
        then 'Thursday'
        when date_part('DOW', date_day) = 5
        then 'Friday'
        when date_part('DOW', date_day) = 6
        then 'Saturday'
    end as day_name,  -- Nombre del día de la semana
    case
        when date_part('DAY', date_day) between 1 and 7
        then '1st Week'  -- Semana del mes
        when date_part('DAY', date_day) between 8 and 14
        then '2nd Week'
        when date_part('DAY', date_day) between 15 and 21
        then '3rd Week'
        when date_part('DAY', date_day) between 22 and 28
        then '4th Week'
        else '5th Week'
    end as week_of_month,  -- Semana del mes (1ª semana, 2ª semana, etc.)
    date_part('DOY', date_day) as day_of_year,  -- Día del año (DOY)
    case
        when date_part('MONTH', date_day) in (12, 1, 2)
        then 'Winter'  -- Estación del año
        when date_part('MONTH', date_day) in (3, 4, 5)
        then 'Spring'
        when date_part('MONTH', date_day) in (6, 7, 8)
        then 'Summer'
        when date_part('MONTH', date_day) in (9, 10, 11)
        then 'Autumn'
    end as season
from dim_date

