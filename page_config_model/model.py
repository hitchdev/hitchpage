from playwright.sync_api._generated import Page as PlaywrightPage
from pathlib import Path
from strictyaml import load, MapPattern, Optional, Str, Map


class PlaywrightPageConfig:
    def __init__(self, *config_files: Path, playwright_page: PlaywrightPage):
        self._config_files = config_files
        self._playwright_page = playwright_page
        self._current_page = None
        self._config_dict = load(
            self._config_files[0].read_text(),
            MapPattern(
                Str(),
                Map(
                    {
                        "element": MapPattern(
                            Str(),
                            Str()
                            | Map(
                                {
                                    Optional("text"): Str(),
                                }
                            ),
                        )
                    }
                ),
            ),
        ).data

    def next_page(self, new_page: str):
        self._current_page = new_page

    @property
    def _page_conf(self):
        return self._config_dict[self._current_page]

    def element(self, name):
        element_dict = self._page_conf["element"][name]
        if isinstance(element_dict, str):
            return self._playwright_page.locator(element_dict)
        else:
            if "text" in element_dict:
                return self._playwright_page.get_by_text(element_dict["text"])
            else:
                raise Exception("Unknown")
