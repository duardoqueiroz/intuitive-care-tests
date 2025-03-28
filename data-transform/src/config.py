import logging
import os


class Logger:
    def __init__(self, name, level, file_handler, formatter):
        self.logger = logging.getLogger(name)
        self.logger.setLevel(level)
        self.logger_file_handler = logging.FileHandler(file_handler, mode="w")
        self.logger_formatter = logging.Formatter(formatter)
        self.logger_file_handler.setFormatter(self.logger_formatter)
        self.logger.addHandler(self.logger_file_handler)


class Config:
    def __init__(self, download_path):
        self.download_path = download_path
        if not os.path.exists(self.download_path):
            os.makedirs(self.download_path)

        self.status_logger_path = os.path.join(self.download_path, "status.log")
        self.status_logger = Logger(
            self.status_logger_path,
            logging.INFO,
            self.status_logger_path,
            "%(asctime)s %(levelname)s %(message)s",
        ).logger
        stream_handler = logging.StreamHandler()
        stream_handler.setLevel(logging.INFO)
        stream_handler.setFormatter(logging.Formatter("%(levelname)s: %(message)s"))
        self.status_logger.addHandler(stream_handler)
