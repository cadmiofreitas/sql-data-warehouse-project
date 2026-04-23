/*
===========================================================
  gold_dim_customers.sql
===========================================================

  Descrição:
    View da dimensão de clientes na camada Gold (Star Schema).
    Consolida dados de 3 tabelas da Silver em uma única
    dimensão desnormalizada.

  Fontes:
    - silver.crm_cust_info (dados principais do cliente)
    - silver.erp_cust_az12 (gênero e data de nascimento)
    - silver.erp_loc_a101 (país)

  Lógica aplicada:
    1. customer_key: surrogate key gerada via ROW_NUMBER,
       ordenada por cst_id.
    2. gender: prioriza o gênero do CRM. Se for 'n/a',
       usa o do ERP via COALESCE.
    3. LEFT JOIN nas duas tabelas do ERP para não perder
       clientes que existem no CRM mas não no ERP.

===========================================================
*/

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,
    ca.bdate AS birthdate,
    ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;
