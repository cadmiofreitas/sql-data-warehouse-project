/*
===========================================================
  gold_dim_products.sql
===========================================================

  Descrição:
    View da dimensão de produtos na camada Gold (Star Schema).
    Consolida dados de produto do CRM com categorias do ERP.

  Fontes:
    - silver.crm_prd_info (dados do produto)
    - silver.erp_px_cat_g1v2 (categoria, subcategoria, manutenção)

  Lógica aplicada:
    1. product_key: surrogate key gerada via ROW_NUMBER,
       ordenada por data de início e chave do produto.
    2. LEFT JOIN com categorias do ERP via cat_id.
    3. Filtra apenas produtos ativos (prd_end_dt IS NULL),
       removendo dados históricos/descontinuados.

===========================================================
*/

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
    pn.prd_id AS product_id,
    pn.prd_key AS product_number,
    pn.prd_nm AS product_name,
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,
    pn.prd_cost AS cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL;
