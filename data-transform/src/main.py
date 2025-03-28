import os
from datetime import datetime

import pandas as pd
import pdfplumber
from config import Config
from utils import zip


def main():
    time = str(datetime.now().strftime("%Y%m%d%H%M%S"))

    downloads_path = os.path.join(os.getcwd(), f"downloads/{time}")

    config = Config(downloads_path)

    pdf_file = os.path.join(os.getcwd(), "data/anexo1.pdf")
    df = extract_all_tables(config, pdf_file)

    if df is not None:
        config.status_logger.info("Salvando dados no arquivo csv")
        df.to_csv(f"{downloads_path}/tables.csv", index=False)
        config.status_logger.info("Compactando arquivo csv")
        zip(f"{downloads_path}/Teste_EDUARDO-LUCIO-DE-QUEIROZ.zip", downloads_path)
        config.status_logger.info("Programa finalizado com sucesso!")


def extract_all_tables(config, pdf_path):
    all_tables = []
    config.status_logger.info("Mapeando tabelas do pdf!")
    with pdfplumber.open(pdf_path) as pdf:
        for page_number, page in enumerate(pdf.pages, start=3):
            tables = page.extract_tables()
            if tables:
                for table in tables:
                    columns_quantity = 13
                    if len(table[0]) < columns_quantity:
                        continue

                    df = pd.DataFrame(
                        table,
                        columns=[
                            "PROCEDIMENTO",
                            "RN(alteração)",
                            "VIGÊNCIA",
                            "Seg. Odontológica",
                            "Seg. Ambulatorial",
                            "HCO",
                            "HSO",
                            "REF",
                            "PAC",
                            "DUT",
                            "SUBGRUPO",
                            "GRUPO",
                            "CAPÍTULO",
                        ],
                    )
                    df.loc[df["Seg. Odontológica"] == "OD", "Seg. Odontológica"] = (
                        "Seg. Odontológica"
                    )
                    df.loc[df["Seg. Ambulatorial"] == "AMB", "Seg. Ambulatorial"] = (
                        "Seg. Ambulatorial"
                    )
                    df = df.drop(index=0)
                    all_tables.append(df)

    if all_tables:
        final_df = pd.concat(all_tables, ignore_index=True)
        config.status_logger.info("Tabelas mapeadas com sucesso!")
        return final_df

    config.status_logger.info("Nenhuma tabela encontrada no PDF.")
    return None


if __name__ == "__main__":
    main()
