Quickstart:
  docs: quickstart
  about: x
  given:
    files:
      selectors.yml: |
        login:
          element:
            username: "#id_username"
            password: "#id_password"
            ok: "#id_ok_button"
        dashboard:
          element:
            dashboard: "#id_this_is_a_dashboard_element"
            message: "#id_dashboard_message"
            next:
              text: next
        iframe:
          element:
            iframe message: "#id_iframe_page"
            
    html:
      index.html: |
        <div class="form-login">
        <input type="text" id="id_username" class="form-control input-sm chat-input" placeholder="username" /></br>
        <input type="text" id="id_password" class="form-control input-sm chat-input" placeholder="password" /></br>
        <div class="wrapper">
        <span class="group-btn">     
        <a id="id_ok_button" href="/dashboard.html" class="btn btn-primary btn-md">login <i class="fa fa-sign-in"></i></a>
        </span>
        </div>
        </div>
      dashboard.html: |
        <div class="form-login">
          <h4 id="id_this_is_a_dashboard_element">Dashboard</h4>
          <p id="id_dashboard_message">hello!</a>
          <a href="/iframe.html" class="btn btn-primary btn-md">next</i></a>
        </div>
      iframe.html: |
        <div class="form-login">
          <h4 id="id_iframe_page">This is an iframe page</h4>
        </div>
    setup: |
      from playwright.sync_api import expect, sync_playwright
      from page_config_model import PlaywrightPageConfig
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
          conf.next_page("login")
          conf.element("username").fill("myusername")
          conf.element("password").fill("mypassword")
          conf.element("ok").click()
            
          conf.next_page("dashboard")
          expect(conf.element("message")).to_be_visible()
          
          conf.element("next").click()
          conf.next_page("iframe")
          expect(conf.element("iframe message")).to_be_visible()
          
