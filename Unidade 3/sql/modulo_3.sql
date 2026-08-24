--Verificando a versão do SQLite
SELECT sqlite_version() AS versao_sqlite;

--Exibindo a estrutura da tabela
 PRAGMA table_info(acidentes_prf_2025); 
 
 -- Contando o número total de ocorrências
 SELECT COUNT(*) AS total_ocorrencias FROM acidentes_prf_2025;
 
 -- Criando a view base com a flag 'acidente_fatal'
 DROP VIEW IF EXISTS vw_acidentes_base; 
 CREATE VIEW vw_acidentes_base AS SELECT *, 
 CASE WHEN CAST(mortos AS INTEGER) >= 1 THEN 1 
 ELSE 0 
 END AS acidente_fatal FROM acidentes_prf_2025; 
 
 -- Calculando indicadores total de acidentes, total de fatais e % de letalidade
 SELECT 
 	COUNT(*) AS total_acidentes,  
 	SUM(acidente_fatal) AS acidentes_fatais, 
 	ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais
 FROM vw_acidentes_base;
 
 -- Agregando indicadores por Estado (UF)
 SELECT 
 	uf, 
	COUNT(*) AS total_acidentes, 
	SUM(acidente_fatal) AS acidentes_fatais, 
	SUM(CAST(mortos AS INTEGER)) AS total_mortos, 
	ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais 
 FROM vw_acidentes_base 
 GROUP BY uf 
 HAVING COUNT(*) >= 100 
 ORDER BY perc_fatais DESC;
 
 -- Listando as 30 rodovias mais letais
 SELECT 
	br, 
	COUNT(*) AS total_acidentes, 
	SUM(CAST(mortos AS INTEGER)) AS total_mortos, 
	SUM(acidente_fatal) AS acidentes_fatais, 
	ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais 
 FROM vw_acidentes_base 
 WHERE br IS NOT NULL 
 GROUP BY br 
 HAVING COUNT(*) >= 100 
 ORDER BY total_mortos DESC 
 LIMIT 30;
 
 -- Evolução temporal dos acidentes por Ano e Mês
 SELECT 
	CAST(strftime('%Y', data_inversa) AS INTEGER) AS ano, 
	CAST(strftime('%m', data_inversa) AS INTEGER) AS mes, 
	COUNT(*) AS total_acidentes, 
	SUM(CAST(mortos AS INTEGER)) AS total_mortos, 
	SUM(acidente_fatal) AS acidentes_fatais, 
	ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais 
 FROM vw_acidentes_base 
 GROUP BY ano, mes 
 ORDER BY ano, mes; 
 
 -- Análise bivariada por Tipo de Acidente e % de ocorrências fatais
 SELECT 
	tipo_acidente, 
	COUNT(*) AS total_acidentes, 
	SUM(acidente_fatal) AS acidentes_fatais, 
	ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais 
 FROM vw_acidentes_base 
 GROUP BY tipo_acidente 
 HAVING COUNT(*) >= 100 
 ORDER BY perc_fatais DESC; 
 
 -- Rankeando as 30 principais causas de acidente por maior taxa de letalidade
 SELECT 
	causa_acidente, 
	COUNT(*) AS total_acidentes, 
	SUM(acidente_fatal) AS acidentes_fatais, 
	ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais 
 FROM vw_acidentes_base 
 GROUP BY causa_acidente 
 HAVING COUNT(*) >= 100 
 ORDER BY perc_fatais DESC 
 LIMIT 30;
 
 
 -- Comparando a gravidade dos acidentes de acordo com a Fase do Dia 
 SELECT 
	fase_dia, 
	COUNT(*) AS total_acidentes, 
	SUM(acidente_fatal) AS acidentes_fatais, 
	ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais 
 FROM vw_acidentes_base 
 group by fase_dia
 having count(*) >= 100
 ORDER BY perc_fatais DESC;
 
 -- Calculando a influência da Condição Meteorológica na % de acidentes fatais 
 SELECT 
	condicao_metereo, 
	COUNT(*) AS total_acidentes, 
	SUM(acidente_fatal) AS acidentes_fatais, 
	ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais 
 FROM vw_acidentes_base 
 GROUP BY condicao_metereo 
 HAVING COUNT(*) >= 100 
 ORDER BY perc_fatais DESC; 
 
 -- Comparando a letalidade do acidente de acordo com o tipo de pista
 SELECT 
	tipo_pista, 
	COUNT(*) AS total_acidentes, 
	SUM(acidente_fatal) AS acidentes_fatais, 
	ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais 
 FROM vw_acidentes_base 
 group by tipo_pista
 having count(*) >= 100
 ORDER BY perc_fatais DESC;
 
 -- Analisando Pista X Fase do dia
 SELECT 
	tipo_pista, 
	fase_dia, 
	COUNT(*) AS total_acidentes, 
	SUM(acidente_fatal) AS acidentes_fatais, 
	ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS cobertura_perc, 
	ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais 
 FROM vw_acidentes_base 
 GROUP BY tipo_pista, fase_dia 
 HAVING COUNT(*) >= 100 
 ORDER BY perc_fatais DESC; 
 
 -- Calculando a razão entre a taxa de letalidade por tipo de acidente 
 WITH taxa_global AS ( 
	SELECT 1.0 * SUM(acidente_fatal) / COUNT(*) AS taxa 
    from vw_acidentes_base   
) 
SELECT 
	tipo_acidente, 
	COUNT(*) AS total_acidentes, 
	SUM(acidente_fatal) AS acidentes_fatais, 
	ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS cobertura_perc, 
	ROUND(1.0 * SUM(acidente_fatal) / COUNT(*), 4) AS confianca, 
	ROUND((1.0 * SUM(acidente_fatal) / COUNT(*)) / taxa, 2) AS lift 
FROM vw_acidentes_base 
CROSS JOIN taxa_global 
GROUP BY tipo_acidente, taxa
having count(*) >= 100
ORDER BY lift DESC; 

-- Criando a view para Indicadores Mensais
DROP VIEW IF EXISTS vw_indicadores_mensais; 

CREATE VIEW vw_indicadores_mensais AS 
SELECT 
	CAST(strftime('%Y', data_inversa) AS INTEGER) AS ano, 
	CAST(strftime('%m', data_inversa) AS INTEGER) AS mes, 
	COUNT(*) AS total_acidentes, 
	SUM(CAST(mortos AS INTEGER)) AS total_mortos, 
	SUM(acidente_fatal) AS acidentes_fatais, 
	ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais 
FROM vw_acidentes_base 
GROUP BY ano, mes; 
 
SELECT * 
FROM vw_indicadores_mensais 
ORDER BY ano, mes;

-- Criando a view para Indicadores por localização
DROP VIEW IF EXISTS vw_indicadores_uf_br; 
 
CREATE VIEW vw_indicadores_uf_br AS 
SELECT 
    uf, 
    br, 
    COUNT(*) AS total_acidentes, 
    SUM(CAST(mortos AS INTEGER)) AS total_mortos, 
    SUM(acidente_fatal) AS acidentes_fatais, 
    ROUND(100.0 * SUM(acidente_fatal) / COUNT(*), 2) AS perc_fatais 
FROM vw_acidentes_base 
WHERE br IS NOT NULL 
GROUP BY uf, br; 
 
SELECT * 
FROM vw_indicadores_uf_br 
ORDER BY total_mortos DESC; 

-- Construindo uma base analítica
DROP VIEW IF EXISTS vw_base_analitica;

CREATE VIEW vw_base_analitica AS
SELECT
 	data_inversa,
 	dia_semana,
 	horario,
 	uf,
 	br,
 	municipio,
 	causa_acidente,
 	tipo_acidente,
 	classificacao_ac,
 	fase_dia,
 	condicao_metereo,
 	tipo_pista,
 	tracado_via,
 	uso_solo,
 	CAST(mortos AS INTEGER) AS mortos,
 	acidente_fatal
FROM vw_acidentes_base;

SELECT *
FROM vw_base_analitica
LIMIT 20;

-- Base para modelagem
DROP VIEW IF EXISTS vw_base_modelavel_preliminar;

CREATE VIEW vw_base_modelavel_preliminar AS
SELECT
 	uf,
 	br,
    municipio,
    CAST(strftime('%m', data_inversa) AS INTEGER) AS mes,
 	dia_semana,
 	fase_dia,
 	causa_acidente,
 	tipo_acidente,
 	condicao_metereo,
 	tipo_pista,
 	tracado_via,
 	uso_solo,
 	acidente_fatal
FROM vw_acidentes_base;

SELECT *
FROM vw_base_modelavel_preliminar
LIMIT 20;