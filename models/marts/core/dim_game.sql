select
    game_id,
    game_title,
    genre,
    platform,
    price,
    release_year,
    age_group_targeted,
    game_length_hours,
    multiplayer,
    min_number_of_players,
    requires_special_device,
    s_soundtrack_quality,
    s_graphics_quality,
    s_story_quality,
    shop_rating,
    shop_review_text
from {{ ref("stg_google_sheets__games") }}
