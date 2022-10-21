-- Checklist de consultas
-- Group by/Having [X]
-- Junção interna [X]
-- Junção externa [X]
-- Semi junção [X]
-- Anti-junção [X]
-- Subconsulta do tipo escalar [X]  
-- Subconsulta do tipo linha [X]
-- Subconsulta do tipo tabela [X]
-- Operação de conjunto [X]


-- Selecionar todos os deuses de mitologias da mesma época que o héroi Aquiles
-- SUBCONSULTA DO TIPO ESCALAR

SELECT A.Nome_deus
FROM Adora A
WHERE A.Nac_epoca = (SELECT H.Nac_epoca
                     FROM Heroi H
                     WHERE H.Nome_heroi = 'AQUILES');
                    
-- Selecionar todos os feitos de herois de uma região
-- SUBCONSULTA DO TIPO LINHA

SELECT F.Descricao_feito
FROM Feitos F
WHERE F.nome_heroi IN (SELECT H.Nome_heroi
                       FROM Heroi H
                       WHERE H.Nac_regiao = 'GREGA');
                     

-- Selecionar nome dos templos de mitologias que não possuem criaturas
-- SUBCONSULTA DO TIPO TABELA

SELECT T.Nome_templo
FROM Templo T LEFT JOIN Adora A ON T.Nome_deus = A.Nome_deus
WHERE (A.Nac_epoca, A.Nac_regiao) NOT IN (SELECT C.Nac_epoca, C.Nac_regiao
                                          FROM Criatura C);
                                          
-- Selecionar nome dos heróis cujas mitologias de sua região possuem deuses sem funções
-- JUNÇÃO INTERNA

SELECT UNIQUE(H.Nome_heroi)
FROM Heroi H INNER JOIN Mitologia M ON (H.Nac_regiao = M.Nac_regiao)
     INNER JOIN Adora A ON (H.Nac_regiao = A.Nac_regiao)
WHERE A.nome_deus IN (  SELECT D.Nome_deus
                        FROM Deus D
                        WHERE D.Funcao_1 = 'Nao definido' AND D.Funcao_2 = 'Nao definido');

-- Selecionar regiões cujo numero de deuses é maior que a média
-- GROUPBY/HAVING

SELECT A.Nac_regiao, COUNT(A.Nome_deus) as Num_deuses
FROM Adora A
GROUP BY A.Nac_regiao
HAVING COUNT(A.Nome_deus) > (SELECT AVG(num_deuses)
                             FROM (SELECT COUNT(A2.Nome_deus) as num_deuses
                                   FROM Adora A2
                                   GROUP BY A2.Nac_regiao));


-- Contar número médio de mortes por hérois por região
-- GROUP BY/HAVING

SELECT H.Nac_regiao, AVG(H.Mortes) as Media_mortes
FROM Heroi H 
GROUP BY H.Nac_regiao;


-- Selecionar os deuses que nao tem uma linhagem
-- JUNÇÃO EXTERNA

SELECT D.Nome_deus
FROM Deus D LEFT OUTER JOIN Semideus SD ON (D.Nome_deus = SD.Nome_deus)
WHERE SD.Nome_semideus IS NULL;


-- Selecionar os deuses que patronam algum territorio
-- SEMI JUNÇÃO

SELECT D.nome_deus
FROM Deus D 
WHERE EXISTS (SELECT T.Nome_territorio
              FROM Territorio T
              WHERE T.Nome_deus = D.Nome_deus);

-- Selecionar os deuses que não são adorados em um templo
-- ANTI JUNÇÃO

SELECT D.nome_deus
FROM DEUS D
WHERE NOT EXISTS (SELECT *
                  FROM TEMPLO T
                  WHERE T.Nome_deus = D.nome_deus 
                  );

-- Selecionar os deuses que comecam com a letra A e os semi-deus cujo deus termina com a letra S e tem 4 letras
-- OPERACAO DE CONJUNTO

SELECT D.nome_deus
FROM DEUS D
WHERE D.nome_deus LIKE 'A%'
UNION 
SELECT SD.nome_semideus
FROM SEMIDEUS SD
WHERE SD.nome_deus LIKE '___S';
