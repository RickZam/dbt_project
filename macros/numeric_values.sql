{% test numeric_values(model, column_name) %}

-- Test genérico para verificar que los valores de una columna sean numéricos
with validation as (
    select
        {{ column_name }} as value
    from {{ model }}
    where {{ column_name }} is not null
)

select *
from validation
where not value rlike '^[0-9]+$'  -- Verifica que solo contenga dígitos

{% endtest %}
