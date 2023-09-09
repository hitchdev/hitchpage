Setup:
  given:
    setup: |
      from playwright.sync_api import expect, sync_playwright
      from hitchpage import PlaywrightPageConfig
      from pathlib import Path

      browser = sync_playwright().start().chromium.connect("ws://127.0.0.1:3605")
      page = browser.new_page()

      conf = PlaywrightPageConfig(
          *Path(".").glob("*.yml"),    # all .yml files in this folder
          playwright_page=page,
      )

      page.goto("http://localhost:8001")
