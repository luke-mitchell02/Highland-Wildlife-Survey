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
    # Create or retrieve logger
    logger = logging.getLogger()

    if logger.handlers:
        return logger

    logger.setLevel(logging.INFO)  # Will capture all levels from DEBUG and above

    # Create console handler for printing logs to console
    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.DEBUG)  # Will capture all levels from INFO and above
    console_handler.setFormatter(ConsoleFormatter())
    logger.addHandler(console_handler)

    return logger
