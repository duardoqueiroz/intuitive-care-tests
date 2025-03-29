-- Quais as 10 operadoras com maiores despesas em "EVENTOS/ SINISTROS CONHECIDOS OU
-- AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último trimestre?
SELECT     r.razao_social,
           d.vl_saldo_inicial,
           d.vl_saldo_final,
           d.vl_saldo_inicial - d.vl_saldo_final AS despesa,
           d.data
FROM       relatorio_cadop r
INNER JOIN demonstracao_contabel d
ON         r.registro_ans = d.reg_ans
WHERE      d.data >= Now() - interval '3 months'
AND        replace(d.descricao,' ','') = 'EVENTOS/SINISTROSCONHECIDOSOUAVISADOSDEASSISTÊNCIAASAÚDEMEDICOHOSPITALAR'
ORDER BY   despesa DESC limit 10;

-- Quais as 10 operadoras com maiores despesas nessa categoria no último ano?
SELECT     r.razao_social,
           d.vl_saldo_inicial,
           d.vl_saldo_final,
           d.vl_saldo_inicial - d.vl_saldo_final AS despesa,
           d.data
FROM       relatorio_cadop r
INNER JOIN demonstracao_contabel d
ON         r.registro_ans = d.reg_ans
WHERE      d.data >= Now() - interval '1 year'
AND        replace(d.descricao,' ','') = 'EVENTOS/SINISTROSCONHECIDOSOUAVISADOSDEASSISTÊNCIAASAÚDEMEDICOHOSPITALAR'
ORDER BY   despesa DESC limit 10;

