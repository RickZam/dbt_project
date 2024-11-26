with
    src_data as (select * from {{ source("google_sheets", "data") }}),

    base_data as (
        select
            purchase_id,
            platform,
            price,
            game_id,
            quantity_purchased,
            user_id,
            user_rating,
            purchase_date,
            user_review_text,
            -- Reemplazar tildes, diéresis y eliminar caracteres especiales
            regexp_replace(
                translate(
                    game_title, 'áéíóúÁÉÍÓÚäëïöüÄËÏÖÜñÑ', 'aeiouAEIOUaeiouAEIOUnN'
                ),
                '[^a-zA-Z0-9 ]',
                ''
            ) as game_title,

            convert_timezone('UTC', _fivetran_synced) as load_date_utc
        from src_data
    )

select *
from base_data
