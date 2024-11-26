with
    src_users as (select * from {{ source("google_sheets", "users") }}),

    stg_users as (

        select
            user_id,
            LOWER(TRIM(first_name)) AS first_name,
            LOWER(TRIM(last_name)) AS last_name,
            CASE
                WHEN LENGTH(CAST(postal_code AS VARCHAR)) = 5 OR 
                     LENGTH(CAST(postal_code AS VARCHAR)) = 9 
                    THEN CAST(postal_code AS VARCHAR)
                    ELSE 'UNKNOWN'
                END AS postal_code,
            COALESCE(state, 'UNKNOWN') AS state,
            COALESCE(country, 'UNKNOWN') AS country,
            convert_timezone('UTC', _fivetran_synced) as load_date_utc
        from src_users
    )

select *
from stg_users
