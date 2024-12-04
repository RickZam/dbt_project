with
    src_users as (select * from {{ source("google_sheets", "users") }}),

    stg_users as (
        select
            user_id,

            -- Limpieza de espacios y transformación a minúsculas para los nombres
            lower(trim(first_name)) as first_name,
            lower(trim(last_name)) as last_name,

            -- Validación del código postal
            case
                when
                    length(cast(postal_code as varchar)) = 5
                    or length(cast(postal_code as varchar)) = 9
                then cast(postal_code as varchar)
                else 'UNKNOWN'
            end as postal_code,

            -- Validación y limpieza para los campos de estado y país
            case
                when state is null or state = '' then 'UNKNOWN' else trim(state)
            end as state,

            case
                when country is null or country = '' then 'UNKNOWN' else trim(country)
            end as country,

            -- Conversión de la fecha de sincronización a la zona horaria UTC
            convert_timezone('UTC', _fivetran_synced) as load_date_utc

        from src_users
    )
select *
from stg_users
