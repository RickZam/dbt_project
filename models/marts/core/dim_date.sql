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
    date_day as date,
    year(date_day) * 10000 + month(date_day) * 100 + day(date_day) as id_date,
    year(date_day) as year,
    month(date_day) as month,
    monthname(date_day) as month_name,
    year(date_day) * 100 + month(date_day) as year_month_id,
    date_day - 1 as previous_day,
    year(date_day) || weekiso(date_day) || dayofweek(date_day) as year_week_day,
    weekiso(date_day) as week,
    -- Día de la semana (Domingo=0, Sábado=6)
    case
        when date_part('DOW', date_day) = 0
        then 'Sunday'
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
    end as day_name,

    -- Semana del mes (1ª semana, 2ª semana, etc.)
    case
        when date_part('DAY', date_day) between 1 and 7
        then '1st Week'
        when date_part('DAY', date_day) between 8 and 14
        then '2nd Week'
        when date_part('DAY', date_day) between 15 and 21
        then '3rd Week'
        when date_part('DAY', date_day) between 22 and 28
        then '4th Week'
        else '5th Week'
    end as week_of_month,

    -- Día del año (DOY)
    date_part('DOY', date_day) as day_of_year,

     -- Estación del año
    case
        when date_part('MONTH', date_day) in (12, 1, 2)
        then 'Winter' 
        when date_part('MONTH', date_day) in (3, 4, 5)
        then 'Spring'
        when date_part('MONTH', date_day) in (6, 7, 8)
        then 'Summer'
        when date_part('MONTH', date_day) in (9, 10, 11)
        then 'Autumn'
    end as season
from dim_date
