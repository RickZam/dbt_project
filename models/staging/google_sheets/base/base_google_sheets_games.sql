with
    src_games as (select * from {{ source("google_sheets", "games") }}),

    base_games as (
    select
        game_mode,
        user_rating,
        developer,
        publisher,
        story_quality,
        CASE
            WHEN game_length_hours_ IS NOT NULL 
            AND game_length_hours_ != '' 
            AND TRY_CAST(game_length_hours_ AS NUMBER(5,0)) > 0
            THEN CAST(game_length_hours_ AS NUMBER(5,0))
            ELSE 0
        END AS game_length_hours_,
        release_year,
        multiplayer,
        price,
        min_number_of_players,
        requires_special_device,
        graphics_quality,
        genre,
        game_id,
        user_review_text,
        platform_id,
        -- Reemplazar tildes, diéresis y eliminar caracteres especiales
            regexp_replace(
                translate(
                    game_title, 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜñÑ', 'aeiouAEIOUaeiouAEIOUnN'
                ),
                '[^a-zA-Z0-9 ]',
                ''
            ) as game_title,
        soundtrack_quality,
        age_group_targeted,
        platform,
        convert_timezone('UTC', _fivetran_synced) as load_date_utc
        from src_games
    )

select *
from base_games
