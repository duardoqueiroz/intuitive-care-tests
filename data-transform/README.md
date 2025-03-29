# 2. Teste de transformação de dados

## Ambiente utilizado:

- Sistema Operacional: Arch Linux
- Linguagem: Python 3.13.2
- Editor de texto: NeoVim

## O que é necessário para executar o Crawler

- Ter instalado o Python 3 ou superior, juntamente com o Pip

## Como executar:

- Entre no diretório intuitive-care-tests/data-transform

```
$ cd intuitive-care-tests/data-transform
```

- Execute os seguintes comandos para configurar o ambiente virtual necessário para executar a automação:

```
$ python -m venv venv
$ source venv/bin/activate
```

- Execute o seguinte comando para instalar as dependências:

```
$ pip install -r requirements.txt
```

- Execute o seguinte comando para executar a automação:

```
$ python src/main.py
```

Após isso, os arquivos serão baixados e compactados na pasta data-transform/downloads, juntamente com os logs da execução.

Sempre que a automação for executada, uma nova pasta será criada na pasta de downloads, para garantir a unicidade das execuções.
