WITH platform_sales AS (
    -- Total de ventas por plataforma
    SELECT
        p.platform_id,
        p.platform_name,
        p.company_name,
        SUM(d.quantity_purchased) AS total_quantity_sold,  -- Total de unidades vendidas
        SUM(d.price * d.quantity_purchased) AS total_revenue  -- Ingresos totales
    FROM {{ ref("fct_game_sales") }} d
    JOIN {{ ref("dim_platform") }} p ON d.platform_id = p.platform_id  -- Relacionamos con la plataforma
    GROUP BY p.platform_id, p.platform_name, p.company_name
),

country_sales AS (
    -- Total de ventas por país (agrupadas por compañía y su país)
    SELECT
        p.country,
        p.company_name,
        SUM(d.quantity_purchased) AS total_quantity_sold,  -- Total de unidades vendidas por país
        SUM(d.price * d.quantity_purchased) AS total_revenue  -- Ingresos totales por país
    FROM {{ ref("fct_game_sales") }} d
    JOIN {{ ref("dim_platform") }} p ON d.platform_id = p.platform_id  -- Relacionamos con la plataforma
    GROUP BY p.country, p.company_name
)

-- Obtenemos los resultados de ventas por plataforma y país
SELECT
    ps.platform_name,
    ps.total_quantity_sold AS platform_quantity_sold,
    ps.total_revenue AS platform_revenue,
    cs.country,
    cs.total_quantity_sold AS country_quantity_sold,
    cs.total_revenue AS country_revenue
FROM platform_sales ps
JOIN country_sales cs ON ps.company_name = cs.company_name  -- Relacionamos plataformas con los países a través de la compañía
ORDER BY ps.total_quantity_sold DESC, cs.total_quantity_sold DESC  -- Ordenamos por ventas totales


