-- =============================================================
-- SQL Data Warehouse — Inicialização do Banco de Dados
-- =============================================================
-- Autor: Cadmio Santos
-- Data: 2026-04-20
-- Descrição: Criação do banco DataWarehouse com arquitetura
--            medallion (bronze / silver / gold)
-- =============================================================

-- Cria o banco
CREATE DATABASE DataWarehouse;

-- Conecta no banco novo
\c DataWarehouse

-- Cria os schemas dentro dele
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;
