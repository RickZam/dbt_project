{% snapshot game_snapshot %}

    {{
        config(
            target_schema="snapshots",
            unique_key="game_id",
            strategy="timestamp",
            updated_at="_fivetran_synced"
        )
    }}

    select *
    from {{ source("google_sheets", "games") }}

{% endsnapshot %}
