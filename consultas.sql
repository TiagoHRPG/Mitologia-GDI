-- Selecionar todos os deuses de mitologias da mesma época que o héroi Aquiles
-- SUBCONSULTA DO TIPO ESCALAR
SELECT nome_deus
FROM Adora
WHERE nac_epoca = ( SELECT nac_epoca
                    FROM Heroi
                    WHERE nome_heroi = 'AQUILES');
                    
-- Selecionar todos os feitos de herois de uma região
-- SUBCONSULTA DO TIPO LINHA
SELECT descricao_feito
FROM Feitos
WHERE nome_heroi IN (SELECT nome_heroi
                     FROM Heroi
                     WHERE nac_regiao = 'GREGA');
                     

-- Selecionar nome dos templos de mitologias que não possuem criaturas
-- SUBCONSULTA DO TIPO TABELA
-- LEFT JOIN (Semi- Junção)
SELECT T.nome_templo
FROM Templo T LEFT JOIN Adora A ON T.nome_deus = A.nome_deus
WHERE (A.nac_epoca, A.nac_regiao) NOT IN (SELECT nac_epoca, nac_regiao
                                          FROM Criatura);
                                          
-- Selecionar nome dos heróis cujas mitologias de sua região possuem deuses sem funções
-- INNER JOIN (Junção Interna)

SELECT UNIQUE(H.nome_heroi)
FROM Heroi H INNER JOIN Mitologia M ON (H.nac_regiao = M.nac_regiao)
     INNER JOIN Adora A ON (H.nac_regiao = A.nac_regiao)
WHERE A.nome_deus IN (  SELECT nome_deus
                        FROM Deus
                        WHERE funcao_1 = 'Nao definido' AND funcao_2 = 'Nao definido');


