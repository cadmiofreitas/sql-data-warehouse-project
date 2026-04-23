
/*
===========================================================
  bronze_to_silver_erp_px_cat_g1v2.sql
===========================================================

  Descrição:
    Transformação da camada Bronze para Silver da tabela
    erp_px_cat_g1v2. Tabela de categorias de produtos.

  Transformações aplicadas:
    Nenhuma — os dados da camada Bronze já estavam limpos
    e padronizados. Insert direto sem transformações.

  Origem:  bronze.erp_px_cat_g1v2
  Destino: silver.erp_px_cat_g1v2
===========================================================
*/

INSERT INTO silver.erp_px_cat_g1v2 (
    id,
    cat,
    subcat,
    maintenance
)
SELECT
    id,
    cat,
    subcat,
    maintenance
FROM bronze.erp_px_cat_g1v2;
