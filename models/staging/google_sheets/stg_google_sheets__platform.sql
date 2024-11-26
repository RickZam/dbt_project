with
    src_platform as (
        select * 
        from {{ source("google_sheets", "platform") }}
        
    ),

    base_platform as (

        select
            platform_id,
            platform_name,
            company_name,
            country,
            CONVERT_TIMEZONE('UTC', _fivetran_synced) AS load_date_UTC
        from src_platform
    )

select *
from base_platform
