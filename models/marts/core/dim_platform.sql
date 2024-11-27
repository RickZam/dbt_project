SELECT
    platform_id,
    platform_name,
    company_name,
    country
FROM {{ ref('stg_google_sheets__platform') }}