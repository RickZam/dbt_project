{% test no_special_charts(model, column_name) %}

SELECT *
FROM {{this}}
WHERE regexp_replace(
        translate(
            game_title, 
            'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜñÑ', 
            'aeiouAEIOUaeiouAEIOUnN'
        ), 
        '[^a-zA-Z0-9 ]', 
        ''
      ) LIKE '%[^a-zA-Z0-9 ]%'


{% endtest %}