with
    base_games as (select * from {{ ref("base_google_sheets_games") }}),

    stg_games as (
        select
            game_id,

            -- Elimina espacios en blanco adicionales en los títulos de los juegos.
            trim(game_title) as game_title,

            -- Asegura que el precio sea un número positivo o 0.
            case
                when price is not null and price >= 0
                then cast(price as decimal(10, 2))
                else 0
            end as price,

            genre,

            -- Elimina espacios en blanco adicionales.
            trim(platform) as platform,

            platform_id,

            -- Elimina espacios en blanco adicionales.
            trim(developer) as developer,

            -- Elimina espacios en blanco adicionales.
            trim(publisher) as publisher,

            -- Valida que el año de lanzamiento sea un número positivo.
            case
                when release_year is not null and release_year > 0
                then cast(release_year as integer)
                else 0
            end as release_year,

            age_group_targeted,

            game_length_hours_ as game_length_hours,

            multiplayer,
            min_number_of_players,
            requires_special_device,

            -- Mapea los valores de calidad del soundtrack a números enteros.
            case
                when lower(trim(soundtrack_quality)) = 'low'
                then 1
                when lower(trim(soundtrack_quality)) = 'medium'
                then 3
                when lower(trim(soundtrack_quality)) = 'high'
                then 5
                else 0
            end as s_soundtrack_quality,

            -- Mapea los valores de calidad de los gráficos a números enteros.
            case
                when lower(trim(graphics_quality)) = 'low'
                then 1
                when lower(trim(graphics_quality)) = 'medium'
                then 3
                when lower(trim(graphics_quality)) = 'high'
                then 5
                else 0
            end as s_graphics_quality,

            -- Mapea los valores de calidad de la historia a números enteros.
            case
                when lower(trim(story_quality)) = 'low'
                then 1
                when lower(trim(story_quality)) = 'medium'
                then 3
                when lower(trim(story_quality)) = 'high'
                then 5
                else 0
            end as s_story_quality,


            user_rating as shop_rating,

            -- Recorta las reseñas de usuario que excedan 150 caracteres
            case
                when length(trim(user_review_text)) > 150
                then left(trim(user_review_text), 150)
                else trim(user_review_text)
            end as shop_review_text,

            load_date_utc
        from base_games
    )

select *
from stg_games
