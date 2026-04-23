/*
===========================================================
  bronze_to_silver_crm_sales_details.sql
===========================================================

  Descrição:
    Transformação da camada Bronze para Silver da tabela 
    crm_sales_details. Realiza limpeza e padronização dos 
    dados brutos antes de inserir na camada Silver.

  Transformações aplicadas:
    1. Datas (sls_order_dt, sls_ship_dt, sls_due_dt):
       - Valores zerados ou com formato inválido (diferente 
         de 8 dígitos) são convertidos para NULL.
       - Valores válidos são convertidos de INT (YYYYMMDD) 
         para o tipo DATE usando TO_DATE.

    2. Vendas (sls_sales):
       - Se NULL, negativo ou inconsistente com 
         quantidade × preço, é recalculado como:
         sls_quantity * ABS(sls_price).

    3. Preço (sls_price):
       - Se NULL ou negativo, é derivado a partir de:
         sls_sales / sls_quantity.
       - NULLIF evita divisão por zero.

  Origem:  bronze.crm_sales_details
  Destino: silver.crm_sales_details
===========================================================
*/

INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE
        WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt::TEXT) != 8 THEN NULL
        ELSE TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')
    END AS sls_order_dt,
    CASE
        WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt::TEXT) != 8 THEN NULL
        ELSE TO_DATE(sls_ship_dt::TEXT, 'YYYYMMDD')
    END AS sls_ship_dt,
    CASE
        WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt::TEXT) != 8 THEN NULL
        ELSE TO_DATE(sls_due_dt::TEXT, 'YYYYMMDD')
    END AS sls_due_dt,
    CASE
        WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    sls_quantity,
    CASE
        WHEN sls_price IS NULL OR sls_price <= 0
            THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price
FROM bronze.crm_sales_details csd;
