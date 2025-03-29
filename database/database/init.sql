-- Um problema que estava ocorrendo é que nem todos os registros ANS do relatorio_cadop
-- poderiam ser utilizados como chave estrangeira dos outros relatórios, então eu simplesmente ignorei 
-- os erros que isso poderiam acarretar, utilizando o seguinte comando:
SET session_replication_role = 'replica';

-- Tabela temporária utilizada para fazer a cópia dos dados do relatório_cadop
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

-- Tabela temporária utilizada para fazer a cópia dos dados dos csvs
CREATE TEMP TABLE temp_demonstracao_contabel(
   data TEXT 
  ,reg_ans TEXT 
  ,cd_conta_contabil TEXT
  ,descricao         TEXT
  ,vl_saldo_inicial  TEXT  
  ,vl_saldo_final    TEXT 
);

-- Tabela original do relatório_cadop
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

-- Tabela original referente aos outros relatórios
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


-- Realizando a cópia do relatorio_cadop.csv para a tabela temporária
COPY temp_relatorio_cadop(registro_ans,cnpj,razao_social,nome_fantasia,modalidade,logradouro,numero,complemento,bairro,cidade,uf,cep,ddd,telefone,fax,endereco_eletronico,representante,cargo_representante,regiao_de_comercializacao,data_registro_ans)
    FROM '/fixtures/relatorio_cadop.csv'
    DELIMITER ';' csv header;

-- Realizando a inserção dos dados a partir da tabela temporária, fazendo as devidas conversões e padronizando os dados
INSERT INTO relatorio_cadop(registro_ans,cnpj,razao_social,nome_fantasia,modalidade,logradouro,numero,complemento,bairro,cidade,uf,cep,ddd,telefone,fax,endereco_eletronico,representante,cargo_representante,regiao_de_comercializacao,data_registro_ans)
   SELECT 
      registro_ans::INTEGER,
      cnpj,
      UPPER(razao_social),
      UPPER(nome_fantasia),
      UPPER(modalidade),
      UPPER(logradouro),
      numero,
      UPPER(complemento),
      UPPER(bairro),
      UPPER(cidade),
      UPPER(uf),
      cep,
      ddd,
      telefone,
      fax,  
      endereco_eletronico,
      UPPER(representante),
      UPPER(cargo_representante),
      regiao_de_comercializacao::INTEGER,
      data_registro_ans::DATE
   FROM temp_relatorio_cadop;
      

-- Realizando a cópia dos dados do relatório 4T2023.csv para a tabela temporária
COPY temp_demonstracao_contabel(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial, vl_saldo_final)
    FROM '/fixtures/4T2023.csv'
    DELIMITER ';' csv header;

-- Inserindo os dados na tabela original
-- inseri primeiro os dados desse csv porque eles diferem um pouco dos outros csvs.
INSERT INTO demonstracao_contabel(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial, vl_saldo_final)
   SELECT 
      TO_DATE(data,'DD/MM/YYYY'),
      reg_ans::INTEGER,
      cd_conta_contabil::INTEGER,
      UPPER(descricao),
      REPLACE(vl_saldo_inicial,',','.')::NUMERIC,
      REPLACE(vl_saldo_final,',','.')::NUMERIC
   FROM temp_demonstracao_contabel;

-- Realizando a cópia dos dados dos outros csvs para a tabela temporária

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

-- Inserindo os dados na tabela original
INSERT INTO demonstracao_contabel(data,reg_ans,cd_conta_contabil,descricao,vl_saldo_inicial, vl_saldo_final)
   SELECT 
      CAST(data as DATE),
      reg_ans::INTEGER,
      cd_conta_contabil::INTEGER,
      UPPER(descricao),
      REPLACE(vl_saldo_inicial,',','.')::NUMERIC,
      REPLACE(vl_saldo_final,',','.')::NUMERIC
   FROM temp_demonstracao_contabel; 


-- Desfazendo a configuração da primeira linha
SET session_replication_role = 'origin';
