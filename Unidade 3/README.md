# 📊 Unidade 3 — Análise de Dados com SQL

Nesta unidade, o foco foi a utilização de **SQL** para consultar, explorar e transformar dados, avançando nas etapas de análise iniciadas nos módulos anteriores.

## 🎯 Objetivo

Desenvolver a capacidade de utilizar SQL para realizar consultas em uma base de dados, extraindo informações relevantes e produzindo resultados que possam apoiar a análise e a tomada de decisões.

A atividade também teve como objetivo aprofundar a exploração da base de acidentes da **Polícia Rodoviária Federal (PRF)**, utilizando consultas para responder a diferentes questões analíticas.

## 🗄️ Banco de dados e consultas

Foi utilizado um banco de dados em formato **SQLite**, contendo os dados de acidentes da PRF de 2025.

As consultas desenvolvidas foram organizadas no arquivo:

- `modulo_3.sql` — arquivo contendo as consultas SQL desenvolvidas durante a atividade;
- `acidentes_prf_2025.db` — banco de dados utilizado para realização das consultas.

## 📈 Resultados da análise

A partir das consultas SQL, foram gerados diferentes arquivos com resultados das análises, permitindo investigar aspectos como:

- estrutura da tabela;
- métricas gerais dos acidentes;
- acidentes por Unidade Federativa (UF);
- acidentes por rodovia (BR);
- acidentes por mês;
- tipos de acidentes;
- principais causas de acidentes;
- acidentes por fase do dia;
- acidentes por condição meteorológica;
- letalidade por tipo de pista;
- relação entre tipo de pista e fase do dia;
- razão e taxa de letalidade por tipo de acidente.

Os resultados foram exportados em arquivos `.csv` e organizados na pasta `resultados/`.

## 🧠 Aprendizados

Nesta etapa, foi possível desenvolver conhecimentos relacionados à **consulta e manipulação de dados utilizando SQL**, compreendendo como extrair informações específicas de uma base e transformar os resultados em dados úteis para análise.

A atividade também permitiu trabalhar com diferentes formas de agrupamento, filtragem e agregação dos dados, utilizando consultas para responder perguntas analíticas específicas.

Além disso, a organização dos resultados em arquivos separados possibilitou compreender o processo de transformar consultas em **resultados estruturados que podem ser utilizados nas etapas posteriores do projeto**.

## 📁 Estrutura da unidade

```text
Unidade 3/
│
├── resultados/
│   ├── 2_estrutura_da_tabela.csv
│   ├── 6_metricas_gerais.csv
│   ├── 7_acidentes_por_uf.csv
│   ├── 8_acidentes_por_br.csv
│   ├── 9_acidentes_por_mes.csv
│   ├── 10_tipos_de_acidente.csv
│   ├── 11_causas_acidentes.csv
│   ├── 12_acidentes_por_fasedodia.csv
│   ├── 13_acidentes_por_condicao_meteorologica.csv
│   ├── 14_letalidade_por_tipo_de_pista.csv
│   ├── 15_pista_fasedodia.csv
│   ├── 16_razao_taxa_letalidade_por_tipo_de_acidente.csv
│   ├── 17_base_analitica.csv
│   └── 18_base_para_modelagem.csv
│
└── sql/
    ├── acidentes_prf_2025.db
    └── modulo_3.sql
