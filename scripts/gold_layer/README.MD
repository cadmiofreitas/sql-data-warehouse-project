## Gold Layer — Data Model

### Modelo escolhido: Star Schema

**Justificativa:**
- Projeto de pequena escala, sem necessidade de normalização 
  complexa da camada analítica.
- Star Schema oferece queries mais simples e performáticas 
  para análise, com JOINs diretos entre fato e dimensões.
- Amplamente adotado no mercado para data warehouses 
  analíticos, facilitando integração com ferramentas de BI 
  (Power BI, Tableau, Looker).
- A desnormalização das dimensões é aceitável neste contexto 
  dado o volume reduzido de dados.

**Trade-off reconhecido:**
- Em cenários de grande escala com dimensões muito grandes, 
  o Snowflake Schema poderia reduzir redundância. Para este 
  projeto, a simplicidade do Star Schema compensa.
