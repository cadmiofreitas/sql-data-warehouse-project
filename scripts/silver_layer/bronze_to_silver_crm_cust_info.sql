-- =============================================================
-- SQL Data Warehouse — Transformação Bronze → Silver
-- Tabela: crm_cust_info
-- =============================================================
-- Autor: Cadmio Santos
-- Data: 2026-04-20
-- Descrição: Limpeza e padronização dos dados de clientes CRM
--            - Deduplicação por cst_id (registro mais recente)
--            - TRIM em firstname e lastname
--            - Padronização de marital_status (S/M → Single/Married)
--            - Padronização de gender (F/M → Female/Male)
-- =============================================================

INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname)         AS cst_firstname,
    TRIM(cst_lastname)          AS cst_lastname,
    CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
         WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
         ELSE 'n/a'
    END                         AS cst_marital_status,
    CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
         WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
         ELSE 'n/a'
    END                         AS cst_gndr,
    cst_create_date
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) t
WHERE flag_last = 1;
