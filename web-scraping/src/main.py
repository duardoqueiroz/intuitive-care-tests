import os
import shutil
from datetime import datetime

import requests
from config import Config
from crawler import Crawler
from utils import zip


def main():

    url = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos"
    time = str(datetime.now().strftime("%Y%m%d%H%M%S"))

    downloads_path = os.path.join(os.getcwd(), f"downloads/{time}")

    config = Config(url, downloads_path)

    crawl_files(config)

    zip(f"{downloads_path}.zip", downloads_path)
    shutil.rmtree(downloads_path)


def crawl_files(config):
    try:
        config.status_logger.info("Iniciando crawler!")
        config.headless = False
        config.limit_await = 15
        crawler = Crawler(config)

        crawler.redirect_to(config.url)
        file1 = crawler.get_link(
            "/html/body/div[2]/div[1]/main/div[2]/div/div/div/div/div[2]/div/ol/li[1]/a[1]"
        )
        file2 = crawler.get_link(
            "/html/body/div[2]/div[1]/main/div[2]/div/div/div/div/div[2]/div/ol/li[2]/a"
        )

        download_file_by_url(config, file1, "anexo1")
        download_file_by_url(config, file2, "anexo2")

        close_driver(config, crawler)

        config.status_logger.info("Crawler finalizado!")
    except Exception as e:
        message = f"Erro ao executar crawler: {e}"
        config.status_logger.error(message)


def download_file_by_url(config, url, filename):
    try:
        config.status_logger.info(f"Baixando arquivo pela url {url}")
        response = requests.get(url)
        file_name = os.path.join(config.download_path, f"{filename}.pdf")
        with open(file_name, "wb") as temp_file:
            temp_file.write(response.content)
    except Exception as e:
        message = f"Erro ao baixar arquivo: {e}"
        config.status_logger.error(message)


def close_driver(config, crawler):
    try:
        config.status_logger.info("Fechando driver")
        crawler.driver.quit()
    except Exception as e:
        message = f"Erro ao fechar crawler: {e}"
        config.status_logger.error(message)


if __name__ == "__main__":
    main()
