import logging


class ConsoleFormatter(logging.Formatter):
    blue = "\x1b[38;5;45m"
    green = '\033[92m'
    yellow = "\x1b[33;20m"
    red = "\x1b[31;20m"
    bold_red = "\x1b[31;1m"
    reset = "\x1b[0m"

    FORMAT_STR = "%(asctime)s [%(levelname)s]: %(message)s"

    FORMATS = {
        logging.DEBUG: blue + FORMAT_STR + reset,
        logging.INFO: green + FORMAT_STR + reset,
        logging.WARNING: yellow + FORMAT_STR + reset,
        logging.ERROR: red + FORMAT_STR + reset,
        logging.CRITICAL: bold_red + FORMAT_STR + reset
    }

    def format(self, record):
        record.levelname = record.levelname.upper()
        log_fmt = self.FORMATS.get(record.levelno)
        formatter = logging.Formatter(log_fmt, datefmt='%d-%b-%y %H:%M:%S')
        return formatter.format(record)


def get_logger() -> logging.Logger:
    logger = logging.getLogger()

    if logger.handlers:
        return logger

    logger.setLevel(logging.INFO)

    # Log to console
    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.DEBUG)
    console_handler.setFormatter(ConsoleFormatter())
    logger.addHandler(console_handler)

    # Log errors to file
    file_handler = logging.FileHandler("./src/logs/process.log")
    file_handler.setLevel(logging.WARNING)
    file_handler.setFormatter(logging.Formatter("%(asctime)s [%(levelname)s]: %(message)s", datefmt='%d-%b-%y %H:%M:%S'))
    logger.addHandler(file_handler)

    return logger
