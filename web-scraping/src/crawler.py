from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait


class Crawler:
    def __init__(self, config):
        self.config = config
        self.url = config.url
        self.limit_await = config.limit_await
        self.driver = self.create_driver(config.download_path)

    def create_driver(self, download_directory):
        try:
            chrome_options = webdriver.ChromeOptions()
            chrome_options.add_argument("--disable-web-fonts")
            chrome_options.add_argument("--disable-gpu")
            chrome_options.add_argument("--disable-images")
            if self.config.headless == True:
                chrome_options.add_argument("--headless")
            chrome_options.add_argument("--no-sandbox")
            chrome_options.add_argument("--window-size=1200,800")
            # chrome_options.add_argument("start-maximized")
            chrome_options.add_experimental_option(
                "prefs",
                {
                    "download.default_directory": download_directory,
                    "download.prompt_for_download": False,
                    "download.directory_upgrade": True,
                    "plugins.always_open_pdf_externally": True,
                },
            )
            return webdriver.Chrome(options=chrome_options)
        except Exception as e:
            message = str(e)
            raise Exception(f"{message}\n")

    def redirect_to(self, url):
        try:
            self.driver.get(url)
            WebDriverWait(self.driver, self.config.limit_await).until(
                EC.url_contains(url.split("/")[-1])
            )
        except Exception as e:
            message = f"Erro ao redirecionar para {url}: {str(e)}"
            raise Exception(f"{message}\n")

    def get_link(self, xpath):
        try:
            element = self.driver.find_element(
                by=By.XPATH,
                value=xpath,
            )
            link = element.get_attribute("href")
            return link
        except Exception as e:
            message = f"Erro ao baixar arquivo: {str(e)}"
            raise Exception(f"{message}\n")
