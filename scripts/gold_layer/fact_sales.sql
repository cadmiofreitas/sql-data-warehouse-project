/*
===========================================================
  gold_fact_sales.sql
===========================================================

  Descrição:
    View da tabela fato de vendas na camada Gold (Star Schema).
    Conecta as métricas transacionais com as surrogate keys
    das dimensões de produto e cliente.

  Fontes:
    - silver.crm_sales_details (dados transacionais)
    - gold.dim_products (surrogate key do produto)
    - gold.dim_customers (surrogate key do cliente)

  Lógica aplicada:
    1. LEFT JOIN com dim_products via sls_prd_key = product_number
       para trazer a product_key (surrogate key).
    2. LEFT JOIN com dim_customers via sls_cust_id = customer_id
       para trazer a customer_key (surrogate key).
    3. Aliases aplicados para nomes de negócio legíveis.

===========================================================
*/

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num AS order_number,
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
