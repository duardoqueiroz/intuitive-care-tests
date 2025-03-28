#!/bin/bash

echo "Aguardando PostgreSQL..."
sleep 10

echo "Importando dados CSV..."
PGPASSWORD=12345678 psql -h intuitive_care -U intuitive_care -d intuitive_care -c "\copy demonstracao_contabel(DATA,REG_ANS,CD_CONTA_CONTABIL,DESCRICAO,VL_SALDO_INICIAL, VL_SALDO_FINAL) FROM 'data/4T2023.csv' DELIMITER ';' CSV"

echo "Importação concluída!"
