# 3. Teste de banco de dados

## Ambiente utilizado:

- Sistema Operacional: Arch Linux
- Linguagem: Python 3.13.2
- Editor de texto: NeoVim
- Docker: Docker version 28.0.1
- Docker Compose version 2.33.1

## O que é necessário para executar o Crawler

- Ter o Docker instalado (utilizei a versão 28.0.1),
- Ter o Docker-compose instalado (utilizei a versão 2.33.1),

## Como executar:

- Entre no diretório intuitive-care-tests/database

```
$ cd intuitive-care-tests/database
```

- Pare e remova os containers do docker-compose.yaml:

```
$ docker-compose down -v
```

- Realize o build dos serviços do docker-compose.yaml :

```
$ docker-compose build
```

- Crie e inicie os containers do docker-compose:

```
$ docker-compose up -d
```

Executando esses comandos, o arquivo database/init.sql será executado dentro do container, criando todas as
tabelas e realizando as inserções.

Dentro do arquivo, vão ter comentários explicando o código em detalhes.

## Acessando o banco de dados e realizando as queries:

- Acesse o terminal do container

```
$ docker exec -it intuitive_care_database sh
```

- Através do psql, acesse o shell sql do PostgreSQL

```
$ psql -U intuitive_care
```

- Para ver as tabelas do banco de dados:

```
$ \dt
```

- Para se conectar ao banco

```
$ \c intuitive_care
```

Após realizar a conexão, as queries do arquivo queries.sql poderão ser feitas. Bastar copiar e executar;

## Resultados das perguntas

### Pergunta 1: Quais as 10 operadoras com maiores despesas em "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último trimestre?

Resultado:
| razao_social | vl_saldo_inicial | vl_saldo_final | despesa | data |
| -------------| ------------- | ------------- | --------| ---- |
(0 rows)

Não há linhas retornadas para essa query, pois não há registro do último trimestre

### Pergunta 2: Quais as 10 operadoras com maiores despesas nessa categoria no último ano?

Resultado:
| razao_social | vl_saldo_inicial | vl_saldo_final | despesa | data
---------------|------------------|----------------|---------|-------------
| HAPVIDA ASSISTENCIA MEDICA S.A. | 116198901.2 | -127840720.03 | 244039621.23 | 2024-10-01
| NOTRE DAME INTERMÉDICA SAÚDE S.A. | 23591364.89 | -181349151.13 | 204940516.02 | 2024-10-01
| AMIL ASSISTÊNCIA MÉDICA INTERNACIONAL S.A. | 887620362.89 | 821149281.28 | 66471081.61 | 2024-10-01
| ASSOCIAÇÃO PETROBRAS DE SAÚDE - APS | 189697190.76 | 128629611.43 | 61067579.33 | 2024-10-01
| CLINIPAM CLINICA PARANAENSE DE ASSISTENCIA MEDICA LTDA | 6977606.44 | -13784896.92 | 20762503.36 | 2024-10-01
| UNIMED PORTO ALEGRE - COOPERATIVA MÉDICA LTDA. | 26695020.18 | 16868688.67 | 9826331.51 | 2024-10-01
| UNIMED NACIONAL - COOPERATIVA CENTRAL | 3843591.05 | -3510753.73 | 7354344.78 | 2024-04-01
| ASSOCIAÇÃO PETROBRAS DE SAÚDE - APS | 130354542.03 | 123129957.64 | 7224584.39 | 2024-10-01
| CENTRO CLÍNICO GAÚCHO LTDA | 1797584.51 | -4482762.91 | 6280347.42 | 2024-10-01
| UNIMED DE MANAUS COOP. DO TRABALHO MÉDICO LTDA | 9983866.87 | 4822026.72 | 5161840.15 | 2024-07-01
(10 rows)
