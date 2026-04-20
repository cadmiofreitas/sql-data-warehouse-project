# SQL Data Warehouse Project

## Overview

This project builds a structured Data Warehouse using PostgreSQL, following the Medallion Architecture (Bronze → Silver → Gold layers).

Data is ingested from three CSV source files:

- `cust_info` — customer records
- `prd_info` — product catalog
- `sales_details` — transactional data

---

## Architecture

### Bronze Layer

Stores raw, unprocessed data exactly as received from the source files. No transformations are applied.

- **Load method:** Full Load (Truncate & Insert)
- **Object type:** Tables

### Silver Layer

Applies data cleaning, standardization, normalization, derived columns, and enrichment. Prepares data for analysis.

- **Load method:** Full Load (Truncate & Insert)
- **Object type:** Tables

### Gold Layer

Delivers business-ready data through integrated, aggregated views with business logic applied. Designed for reporting and analytics consumption.

- **Load method:** None
- **Object type:** Views

---

## Tech Stack

- **Database:** PostgreSQL
- **Architecture:** Medallion (Bronze / Silver / Gold)
- **Source format:** CSV files

---

## Goals

- Practice real-world Data Warehouse design
- Apply SQL transformations layer by layer
- Produce clean, analytics-ready data

---

---

# Projeto SQL Data Warehouse

## Visão Geral

Este projeto constrói um Data Warehouse estruturado utilizando PostgreSQL, seguindo a Arquitetura Medallion (camadas Bronze → Silver → Gold).

Os dados são ingeridos a partir de três arquivos CSV:

- `cust_info` — registros de clientes
- `prd_info` — catálogo de produtos
- `sales_details` — dados de vendas

---

## Arquitetura

### Camada Bronze

Armazena os dados brutos exatamente como recebidos das fontes. Nenhuma transformação é aplicada.

- **Método de carga:** Full Load (Truncate & Insert)
- **Tipo de objeto:** Tabelas

### Camada Silver

Aplica limpeza, padronização, normalização, colunas derivadas e enriquecimento dos dados. Prepara os dados para análise.

- **Método de carga:** Full Load (Truncate & Insert)
- **Tipo de objeto:** Tabelas

### Camada Gold

Entrega dados prontos para o negócio por meio de views integradas, agregadas e com regras de negócio aplicadas. Voltada para relatórios e analytics.

- **Método de carga:** Nenhum
- **Tipo de objeto:** Views

---

## Stack Tecnológica

- **Banco de dados:** PostgreSQL
- **Arquitetura:** Medallion (Bronze / Silver / Gold)
- **Formato de entrada:** Arquivos CSV

---

## Objetivos

- Praticar design real de Data Warehouse
- Aplicar transformações SQL camada por camada
- Produzir dados limpos e prontos para análise
