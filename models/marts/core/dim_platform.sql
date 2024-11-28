select 
    platform_id, 
    platform_name, 
    company_name, 
    country
from {{ ref("stg_google_sheets__platform") }}
