with
    base_data as (select * from {{ ref("base_google_sheets_data") }}),

    stg_data as (
        select
            purchase_id,  -- Identificador único de cada compra.
            purchase_date,  -- Fecha en la que se realizó la compra.
            quantity_purchased,  -- Cantidad de unidades compradas.
            game_id,  -- Identificador único del juego.

            -- Elimina espacios en blanco adicionales en los títulos de los juegos.
            trim(game_title) as game_title,

            -- Asegura que el precio sea un número positivo o 0, con formato decimal (10,2).
            -- Además, si el precio es nulo o negativo, se asigna un valor de 0.
            case
                when price is not null and price >= 0
                then cast(price as decimal(10, 2))
                else 0
            end as price,

            -- Elimina espacios en blanco adicionales en el nombre de la plataforma.
            trim(platform) as platform,

            user_id,  -- Identificador único del usuario.

            -- Verifica que la calificación del usuario sea un número decimal entre 1
            -- y 5.
            -- Si no cumple las condiciones o es nulo, se asigna un valor
            -- predeterminado de 0.
            case
                when
                    cast(user_rating as decimal(2, 1)) is not null
                    and user_rating between 1 and 5
                then cast(user_rating as decimal(2, 1))
                else 0
            end as user_rating,

            -- Recorta las reseñas de usuario que superen los 150 caracteres para garantizar
            -- que los textos sean manejables, eliminando también espacios en blanco adicionales.
            case
                when length(trim(user_review_text)) > 150
                then left(trim(user_review_text), 150)
                else trim(user_review_text)
            end as user_review_text,

            load_date_utc  -- Fecha y hora de carga en formato UTC.
        from base_data
    )

select *
from stg_data
