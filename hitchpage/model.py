from playwright.sync_api._generated import Page as PlaywrightPage
from pathlib import Path
from strictyaml import load, MapPattern, Optional, Str, Map



class ElementLookup:
    def __init__(self, conf):
        self._conf = conf

    def __getitem__(self, key):
        return self._conf[key]

    @property
    def simple_locator(self):
        return isinstance(self._conf, str)

    @property
    def is_locator(self):
        return isinstance(self._conf, str) or "locator" in self._conf

    @property
    def in_iframe(self):
        return "in iframe" in self._conf

    @property
    def locator(self):
        if isinstance(self._conf, str):
            return self._conf
        elif "locator" in self._conf:
            return self._conf["locator"]
        else:
            raise Exception("locator not available")


class PlaywrightPageConfig:
    def __init__(self, *config_files: Path, playwright_page: PlaywrightPage):
        self._config_files = config_files
        self._playwright_page = playwright_page
        self._current_page = None
        self._config_dict = {
            page_name: {
                "element": {
                    element: ElementLookup(element_conf)
                    for element, element_conf in 
                    page_conf["element"].items()
                }
            } for page_name, page_conf in 
            load(
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
                                        Optional("locator"): Str(),
                                        Optional("in iframe"): Str(),
                                    }
                                ),
                            )
                        }
                    ),
                ),
            ).data.items()
        }

    def next_page(self, new_page: str):
        self._current_page = new_page

    @property
    def _page_conf(self):
        return self._config_dict[self._current_page]

    def _get_iframe(self, which_iframe):
        return self._playwright_page.frame_locator(
            self._page_conf["element"][which_iframe].locator
        )

    def element(self, name):
        element_dict = self._page_conf["element"][name]
        
        if element_dict.simple_locator:
            return self._playwright_page.locator(element_dict.locator)
        else:
            if "in iframe" in element_dict._conf:
                page = self._get_iframe(element_dict["in iframe"])
            else:
                page = self._playwright_page

            if "locator" in element_dict._conf:
                return page.locator(element_dict["locator"])
            elif "text" in element_dict:
                return page.get_by_text(element_dict["text"])
            else:
                raise Exception("Bad error")
