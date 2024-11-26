-- tests/game_title_no_special_chars.sql
-- Prueba para asegurar que los títulos de los juegos no contienen caracteres especiales después de la limpieza.

SELECT *
FROM {{ ref('base_games') }}
WHERE game_title LIKE '%[^a-zA-Z0-9 ]%';

-- tests/purchase_data_valid.sql
-- Prueba para asegurar que los datos de compra son válidos y están completos.

SELECT *
FROM {{ ref('base_data') }}
WHERE purchase_id IS NULL
  OR user_id IS NULL
  OR game_id IS NULL
  OR price IS NULL
  OR purchase_date IS NULL;

-- tests/game_id_unique.sql
-- Prueba para asegurar que el game_id es único en la tabla base_games.

SELECT game_id
FROM {{ ref('base_games') }}
GROUP BY game_id
HAVING COUNT(*) > 1;

-- tests/platform_id_unique.sql
-- Prueba para asegurar que el platform_id es único en la tabla base_games.

SELECT platform_id
FROM {{ ref('base_games') }}
GROUP BY platform_id
HAVING COUNT(*) > 1;

-- tests/purchase_id_unique.sql
-- Prueba para asegurar que el purchase_id es único en la tabla base_data.

SELECT purchase_id
FROM {{ ref('base_data') }}
GROUP BY purchase_id
HAVING COUNT(*) > 1;

-- tests/user_id_unique.sql
-- Prueba para asegurar que el user_id es único en la tabla base_data.

SELECT user_id
FROM {{ ref('base_data') }}
GROUP BY user_id
HAVING COUNT(*) > 1;
