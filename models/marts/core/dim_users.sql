select 
    user_id, 
    first_name, 
    last_name, 
    postal_code, 
    state, 
    country
from {{ ref("stg_google_sheets__users") }}
