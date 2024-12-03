SELECT *
FROM {{ this }}
WHERE game_title LIKE '%[^a-zA-Z0-9 ]%';