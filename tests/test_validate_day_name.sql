SELECT *
FROM {{ ref('dim_date') }}
WHERE day_name NOT IN ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')
