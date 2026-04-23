/*
===========================================================
  bronze_to_silver_erp_loc_a101.sql
===========================================================

  Descrição:
    Transformação da camada Bronze para Silver da tabela
    erp_loc_a101. Realiza limpeza e padronização dos
    dados de localização de clientes vindos do ERP.

  Transformações aplicadas:
    1. ID do cliente (cid):
       - Remove hífens do código do cliente usando REPLACE.

    2. País (cntry):
       - Padroniza abreviações:
         'DE' → 'Germany'
         'US', 'USA' → 'United States'
       - Valores vazios ou NULL → 'n/a'
       - Demais valores mantidos com TRIM aplicado.

  Origem:  bronze.erp_loc_a101
  Destino: silver.erp_loc_a101
===========================================================
*/

INSERT INTO silver.erp_loc_a101 (cid, cntry)
SELECT
    REPLACE(cid, '-', '') AS cid,
    CASE 
        WHEN TRIM(cntry) = 'DE' THEN 'Germany'
        WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
        ELSE TRIM(cntry)
    END AS cntry
FROM bronze.erp_loc_a101 ela;
