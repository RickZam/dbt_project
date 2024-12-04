{{ config(
    materialized='incremental',
    unique_key = 'purchase_id'
    ) 
    }}

with
    base_data as (select * from {{ ref("base_google_sheets_data") }}),

    stg_data as (
        select
            purchase_id,
            purchase_date,
            quantity_purchased,
            game_id,

            -- Elimina espacios en blanco adicionales.
            trim(game_title) as game_title,

            -- Asegura que el precio sea un número positivo o 0.
            case
                when price is not null and price >= 0
                then cast(price as decimal(10, 2))
                else 0
            end as price,

            -- Elimina espacios en blanco adicionales.
            trim(platform) as platform,

            user_id,

            -- Verifica que la calificación del usuario sea un número decimal entre 1
            -- y 5.
            case
                when
                    cast(user_rating as decimal(2, 1)) is not null
                    and user_rating between 1 and 5
                then cast(user_rating as decimal(2, 1))
                else 0
            end as user_rating,

            -- Recorta las reseñas de usuario que superen los 150 caracteres.
            case
                when length(trim(user_review_text)) > 150
                then left(trim(user_review_text), 150)
                else trim(user_review_text)
            end as user_review_text,

            load_date_utc
        from base_data
    )

select *
from stg_data

{% if is_incremental() %}

  where load_date_utc > (select max(load_date_utc) from {{ this }})

{% endif %}