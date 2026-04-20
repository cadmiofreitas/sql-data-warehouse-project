import psycopg2
import os

# =============================================================
# SQL Data Warehouse — Carga Bronze
# =============================================================
# Autor: Cadmio Santos
# Data: 2026-04-20
# Descrição: Ingestão dos CSVs das fontes CRM e ERP
#            na camada bronze do DataWarehouse
# =============================================================

# Caminho base dos datasets (mesmo diretório do script)
BASE_PATH = os.path.dirname(__file__)

# Mapeamento: arquivo CSV -> tabela bronze
TABLES = [
    # CRM
    {
        'file': os.path.join(BASE_PATH, 'cust_info.csv'),
        'table': 'bronze.crm_cust_info'
    },
    {
        'file': os.path.join(BASE_PATH, 'prd_info.csv'),
        'table': 'bronze.crm_prd_info'
    },
    {
        'file': os.path.join(BASE_PATH, 'sales_details.csv'),
        'table': 'bronze.crm_sales_details'
    },
    # ERP
    {
        'file': os.path.join(BASE_PATH, 'CUST_AZ12.csv'),
        'table': 'bronze.erp_cust_az12'
    },
    {
        'file': os.path.join(BASE_PATH, 'LOC_A101.csv'),
        'table': 'bronze.erp_loc_a101'
    },
    {
        'file': os.path.join(BASE_PATH, 'PX_CAT_G1V2.csv'),
        'table': 'bronze.erp_px_cat_g1v2'
    },
]


def get_connection():
    return psycopg2.connect(
        host='localhost',
        port=5432,
        dbname='datawarehouse',
        user='postgres',
        password='123'
    )


def load_table(cur, file_path, table_name):
    print(f'  Carregando {table_name}...', end=' ')
    sql = f"COPY {table_name} FROM STDIN WITH (FORMAT csv, HEADER true, NULL '')"
    with open(file_path, 'r', encoding='utf-8') as f:
        cur.copy_expert(sql, f)
    print('OK')


def run():
    print('=' * 55)
    print('Iniciando carga da camada Bronze')
    print('=' * 55)

    conn = None
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute('SET search_path TO bronze, public;')

        for entry in TABLES:
            file_path = entry['file']
            table_name = entry['table']

            if not os.path.exists(file_path):
                print(f'  AVISO: arquivo não encontrado -> {file_path}')
                continue

            # Limpa a tabela antes de carregar
            cur.execute(f'TRUNCATE TABLE {table_name};')
            load_table(cur, file_path, table_name)

        conn.commit()
        print('=' * 55)
        print('Carga finalizada com sucesso!')
        print('=' * 55)

    except Exception as e:
        if conn:
            conn.rollback()
        print(f'\nERRO: {e}')

    finally:
        if conn:
            conn.close()


if __name__ == '__main__':
    run()
