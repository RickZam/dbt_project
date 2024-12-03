{% test no_special_charts(model, column_name) %}

SELECT *
FROM {{ this }}
WHERE game_title LIKE '%[^a-zA-Z0-9 ]%';

{% endtest %}