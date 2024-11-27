with
    src_platform as (select * from {{ source("google_sheets", "platform") }}),

    stg_platform as (
        select
            platform_id,  -- Identificador único de la plataforma.

            -- Elimina espacios en blanco adicionales en el nombre de la plataforma
            trim(platform_name) as platform_name,

            -- Elimina espacios en blanco adicionales en el nombre de la compañía
            trim(company_name) as company_name,

            -- Elimina espacios en blanco adicionales en el nombre del país
            trim(country) as country,

            -- Convierte la fecha de sincronización a la zona horaria UTC
            convert_timezone('UTC', _fivetran_synced) as load_date_utc
        from src_platform
    )

select *
from stg_platform
