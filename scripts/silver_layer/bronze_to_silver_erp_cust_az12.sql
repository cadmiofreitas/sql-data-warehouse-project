/*
===========================================================
  bronze_to_silver_erp_cust_az12.sql
===========================================================

  Descrição:
    Transformação da camada Bronze para Silver da tabela
    erp_cust_az12. Realiza limpeza e padronização dos
    dados de clientes vindos do ERP.

  Transformações aplicadas:
    1. ID do cliente (cid):
       - Remove o prefixo 'NAS' quando presente,
         extraindo apenas o código real do cliente.

    2. Data de nascimento (bdate):
       - Datas futuras (maiores que a data atual) são
         convertidas para NULL, pois indicam erro de
         cadastro.

    3. Gênero (gen):
       - Padroniza variações de texto:
         'F', 'FAMELE' → 'Female'
         'M', 'MALE'  → 'Male'
         Qualquer outro valor → 'n/a'
       - Aplica TRIM e UPPER antes da comparação para
         tratar espaços e maiúsculas/minúsculas.

  Origem:  bronze.erp_cust_az12
  Destino: silver.erp_cust_az12
===========================================================
*/

INSERT INTO silver.erp_cust_az12 (
    cid,
    bdate,
    gen
)
SELECT
    CASE 
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
        ELSE cid
    END AS cid,
    CASE 
        WHEN bdate > NOW() THEN NULL
        ELSE bdate
    END AS bdate,
    CASE 
        WHEN UPPER(TRIM(gen)) IN ('F', 'FAMELE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
        ELSE 'n/a'
    END AS gen
FROM bronze.erp_cust_az12;
