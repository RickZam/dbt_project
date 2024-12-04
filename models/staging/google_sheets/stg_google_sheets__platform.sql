with
    src_platform as (select * from {{ source("google_sheets", "platform") }}),

    stg_platform as (
        select
            platform_id,

            -- Elimina espacios en blanco adicionales
            trim(platform_name) as platform_name,
            trim(company_name) as company_name,
            trim(country) as country,

            -- Convierte la fecha de sincronización a la zona horaria UTC
            convert_timezone('UTC', _fivetran_synced) as load_date_utc
        from src_platform
    )

select *
from stg_platform
