# 4. Teste de API

## Ambiente utilizado:

- Sistema Operacional: Arch Linux
- Linguagem: Python 3.13.2
- Editor de texto: NeoVim

## O que é necessário para executar o Crawler

- Ter instalado o Python 3 ou superior, juntamente com o Pip

## Como executar:

- Entre no diretório intuitive-care-tests/cadop-api

```
$ cd intuitive-care-tests/cadop-api
```

- Execute os seguintes comandos para configurar o ambiente virtual:

```
$ python -m venv venv
$ source venv/bin/activate
```

- Execute o seguinte comando para instalar as dependências:

```
$ pip install -r requirements.txt
```

- Execute o seguinte comando para rodar o servidor:

```
$ python src/main.py
```

Após isso, o servidor será iniciado em http://localhost:5000
