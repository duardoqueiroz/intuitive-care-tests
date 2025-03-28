SET session_replication_role = 'replica';
CREATE TEMP TABLE temp_demonstracao_contabel(
   data TEXT 
  ,reg_ans TEXT 
  ,cd_conta_contabil TEXT
  ,descricao         TEXT
  ,vl_saldo_inicial  TEXT  
  ,vl_saldo_final    TEXT 
);

CREATE TEMP TABLE temp_relatorio_cadop(
   registro_ans              TEXT
  ,cnpj                      TEXT
  ,razao_social              TEXT
  ,nome_fantasia             TEXT
  ,modalidade                TEXT
  ,logradouro                TEXT
  ,numero                    TEXT
  ,complemento               TEXT
  ,bairro                    TEXT
  ,cidade                    TEXT
  ,uf                        TEXT
  ,cep                       TEXT
  ,ddd			     TEXT
  ,telefone                 TEXT
  ,fax                      TEXT
  ,endereco_eletronico       TEXT
  ,representante             TEXT
  ,cargo_representante       TEXT
  ,regiao_de_comercializacao TEXT
  ,data_registro_ans         TEXT
);

CREATE TABLE relatorio_cadop(
   registro_ans              INTEGER NOT NULL PRIMARY KEY
  ,cnpj                      VARCHAR (14) NOT NULL
  ,razao_social              VARCHAR(200) NOT NULL
  ,nome_fantasia             VARCHAR(200)
  ,modalidade                VARCHAR(200) NOT NULL
  ,logradouro                VARCHAR(200) NOT NULL
  ,numero                    VARCHAR(20) NOT NULL
  ,complemento               VARCHAR(200)
  ,bairro                    VARCHAR(100) NOT NULL
  ,cidade                    VARCHAR(100) NOT NULL
  ,uf                        VARCHAR(2) NOT NULL
  ,cep                       VARCHAR(8) NOT NULL
  ,ddd			   VARCHAR(2) 
  ,telefone                 VARCHAR(20) 
  ,fax                      VARCHAR(50) 
  ,endereco_eletronico       VARCHAR(50)
  ,representante             VARCHAR(50) NOT NULL
  ,cargo_representante       VARCHAR(50) NOT NULL
  ,regiao_de_comercializacao INTEGER 
  ,data_registro_ans         DATE  NOT NULL
);

CREATE TABLE demonstracao_contabel(
   id		     SERIAL PRIMARY KEY
   ,data              DATE  NOT NULL 
  ,reg_ans           INTEGER  NOT NULL
  ,cd_conta_contabil INTEGER  NOT NULL
  ,descricao         VARCHAR(512) NOT NULL
  ,vl_saldo_inicial  NUMERIC NOT NULL DEFAULT 0
  ,vl_saldo_final    NUMERIC NOT NULL DEFAULT 0,

   CONSTRAINT fk_reg_ans FOREIGN KEY (reg_ans) 
     REFERENCES relatorio_cadop(registro_ans)
);

COPY temp_demonstracao_contabel(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial, vl_saldo_final)
    FROM '/fixtures/4T2023.csv'
    DELIMITER ';' csv header;

COPY temp_relatorio_cadop(registro_ans,cnpj,razao_social,nome_fantasia,modalidade,logradouro,numero,complemento,bairro,cidade,uf,cep,ddd,telefone,fax,endereco_eletronico,representante,cargo_representante,regiao_de_comercializacao,data_registro_ans)
    FROM '/fixtures/relatorio_cadop.csv'
    DELIMITER ';' csv header;

INSERT INTO relatorio_cadop(registro_ans,cnpj,razao_social,nome_fantasia,modalidade,logradouro,numero,complemento,bairro,cidade,uf,cep,ddd,telefone,fax,endereco_eletronico,representante,cargo_representante,regiao_de_comercializacao,data_registro_ans)
   SELECT 
      registro_ans::INTEGER,
      cnpj,
      razao_social,
      nome_fantasia,
      modalidade,
      logradouro,
      numero,
      complemento,
      bairro,
      cidade,
      uf,
      cep,
      ddd,
      telefone,
      fax,  
      endereco_eletronico,
      representante,
      cargo_representante,
      regiao_de_comercializacao::INTEGER,
      data_registro_ans::DATE
   FROM temp_relatorio_cadop;
      

INSERT INTO demonstracao_contabel(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial, vl_saldo_final)
   SELECT 
      TO_DATE(data,'DD/MM/YYYY'),
      reg_ans::INTEGER,
      cd_conta_contabil::INTEGER,
      UPPER(descricao),
      REPLACE(vl_saldo_inicial,',','.')::NUMERIC,
      REPLACE(vl_saldo_final,',','.')::NUMERIC
   FROM temp_demonstracao_contabel;

COPY temp_demonstracao_contabel(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial, vl_saldo_final)
    FROM '/fixtures/1T2023.csv'
    DELIMITER ';' csv header;

COPY temp_demonstracao_contabel(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial, vl_saldo_final)
    FROM '/fixtures/2T2023.csv'
    DELIMITER ';' csv header;

COPY temp_demonstracao_contabel(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial, vl_saldo_final)
    FROM '/fixtures/3T2023.csv'
    DELIMITER ';' csv header;

COPY temp_demonstracao_contabel(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial, vl_saldo_final)
    FROM '/fixtures/1T2024.csv'
    DELIMITER ';' csv header;

COPY temp_demonstracao_contabel(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial, vl_saldo_final)
    FROM '/fixtures/2T2024.csv'
    DELIMITER ';' csv header;

COPY temp_demonstracao_contabel(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial, vl_saldo_final)
    FROM '/fixtures/3T2024.csv'
    DELIMITER ';' csv header;

COPY temp_demonstracao_contabel(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial, vl_saldo_final)
    FROM '/fixtures/4T2024.csv'
    DELIMITER ';' csv header;

INSERT INTO demonstracao_contabel(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial, vl_saldo_final)
   SELECT 
      CAST(data as DATE),
      reg_ans::INTEGER,
      cd_conta_contabil::INTEGER,
      UPPER(descricao),
      REPLACE(vl_saldo_inicial,',','.')::NUMERIC,
      REPLACE(vl_saldo_final,',','.')::NUMERIC
   FROM temp_demonstracao_contabel; 

SET session_replication_role = 'origin';

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

