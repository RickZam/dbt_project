{{ config(
    materialized='incremental',
    unique_key = 'purchase_id'
    ) 
    }}

with
    silver as (
        select
            d.purchase_id,
            d.purchase_date,
            d.quantity_purchased,
            d.price,
            d.game_id,
            g.game_title,
            g.genre,
            g.platform,
            g.platform_id,
            d.user_id,
            d.user_rating,
            g.shop_rating,
            d.user_review_text,
            d.platform as purchase_platform,
            d.load_date_utc
        from {{ ref("stg_google_sheets__data") }} d
        left join {{ ref("stg_google_sheets__games") }} g on d.game_id = g.game_id
        
{% if is_incremental() %}

  where d.load_date_utc > (select max(load_date_utc) from {{ this }})

{% endif %}
    )

select
    purchase_id,
    purchase_date,
    quantity_purchased,
    price,
    game_id,
    game_title,
    genre,
    platform,
    platform_id,
    user_id,
    user_rating,
    shop_rating,
    user_review_text,
    purchase_platform,
    load_date_utc
from silver
