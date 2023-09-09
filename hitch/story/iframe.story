Iframe:
  docs: iframe
  about: |
    Look for an element inside an iframe.

    Then look for an element inside an iframe inside an iframe.
  given:
    files:
      selectors.yml: |
        iframe:
          element:
            iframe page title: "#id_iframe_title"
            message iframe:
              locator: "#message_iframe"
            iframe content message:
              in iframe: message iframe
              locator: "#id_dashboard_message"
            
    html:
      index.html: |
        <div class="form-login">
          <h4 id="id_iframe_title">This page contains an iframe</h4>
          <iframe id="message_iframe" src="iframe_content.html" />
        </div>
      iframe_content.html: |
        <p id="id_dashboard_message">hello!</a>
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

  steps:
  - Run:
      code: |
        conf.next_page("iframe")
        print("iframe page")
        expect(conf.element("iframe page title")).to_be_visible()
        expect(conf.element("iframe content message")).to_be_visible()

      will output: |-
        iframe page


