with
    base_games as (select * from {{ ref("base_google_sheets_games") }}),

    stg_games as (
        select
            game_id,  -- Identificador único del juego.

            -- Elimina espacios en blanco adicionales en los títulos de los juegos.
            trim(game_title) as game_title,

            -- Asegura que el precio sea un número positivo o 0, con formato decimal
            -- (10,2).
            -- Además, si el precio es nulo o negativo, se asigna un valor de 0.
            case
                when price is not null and price >= 0
                then cast(price as decimal(10, 2))
                else 0
            end as price,

            genre,  -- Género del juego.

            -- Elimina espacios en blanco adicionales en el nombre de la plataforma.
            trim(platform) as platform,

            platform_id,  -- Identificador único de la plataforma.

            -- Elimina espacios en blanco adicionales en el nombre del estudio
            -- desarrolador.
            trim(developer) as developer,

            -- Elimina espacios en blanco adicionales en el nombre del editor.
            trim(publisher) as publisher,

            -- Valida que el año de lanzamiento sea un número positivo.
            -- Además, si es nulo o inválido, se asigna un valor predeterminado de 0.
            case
                when release_year is not null and release_year > 0
                then cast(release_year as integer)
                else 0
            end as release_year,

            age_group_targeted,  -- Grupo de edad objetivo del juego.

            game_length_hours_ as game_length_hours,

            multiplayer,  -- Indicador de si el juego tiene modo multijugador.
            min_number_of_players,  -- Mínimo número de jugadores necesarios.
            requires_special_device,  -- Indicador de si requiere dispositivos especiales.

            -- Mapea los valores de calidad del soundtrack a números enteros:
            -- Low = 1, Medium = 3, High = 5. Asigna 0 si el valor no coincide.
            case
                when lower(trim(soundtrack_quality)) = 'low'
                then 1
                when lower(trim(soundtrack_quality)) = 'medium'
                then 3
                when lower(trim(soundtrack_quality)) = 'high'
                then 5
                else 0
            end as s_soundtrack_quality,

            -- Mapea los valores de calidad de los gráficos a números enteros:
            -- Low = 1, Medium = 3, High = 5. Asigna 0 si el valor no coincide.
            case
                when lower(trim(graphics_quality)) = 'low'
                then 1
                when lower(trim(graphics_quality)) = 'medium'
                then 3
                when lower(trim(graphics_quality)) = 'high'
                then 5
                else 0
            end as s_graphics_quality,

            -- Mapea los valores de calidad de la historia a números enteros:
            -- Low = 1, Medium = 3, High = 5. Asigna 0 si el valor no coincide.
            case
                when lower(trim(story_quality)) = 'low'
                then 1
                when lower(trim(story_quality)) = 'medium'
                then 3
                when lower(trim(story_quality)) = 'high'
                then 5
                else 0
            end as s_story_quality,


            user_rating as shop_rating, -- Valoración de la tienda sobre el juego en un rango de 1 a 10.

            -- Recorta las reseñas de usuario que excedan 150 caracteres para garantizar
            -- que los textos sean manejables, eliminando también espacios en blanco
            -- adicionales.
            case
                when length(trim(user_review_text)) > 150
                then left(trim(user_review_text), 150)
                else trim(user_review_text)
            end as shop_review_text,

            load_date_utc  -- Fecha y hora de carga en formato UTC.
        from base_games
    )

select *
from stg_games
