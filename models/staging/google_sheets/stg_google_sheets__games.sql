with
    src_games as (select * from {{ ref("base_google_sheets_games") }}),

    base_games as (

        select
            game_id,
            game_title,
            price,
            genre,           
            platform,
            platform_id,
            developer,
            publisher,
            release_year,
            age_group_targeted,
            game_length_hours_,
            game_mode,
            multiplayer,
            min_number_of_players,
            requires_special_device,
            soundtrack_quality,
            graphics_quality,
            story_quality,
            user_rating,
            user_review_text,
            load_date_utc
        from src_games
    )

select *
from base_games
