SELECT
    user_id,
    first_name,
    last_name,
    postal_code,
    state,
    country
FROM {{ ref('stg_google_sheets__users') }}