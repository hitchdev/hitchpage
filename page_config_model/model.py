from pathlib import Path


class PageConfig:
    def __init__(self, *config_files: Path):
        self._config_files = config_files
        
