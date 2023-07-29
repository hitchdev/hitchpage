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

    website:
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
          <h4 id="id_this_is_a_dashboard_element">Dashboard</h4>  <p id="id_dashboard_message">hello!</a>
        </div>

  steps:
    - Run:
        code: |
          from playwright.sync_api import expect, sync_playwright
          from page_config_model import PageConfig
          from pathlib import Path
            
          browser = sync_playwright().start().chromium
          page = browser.new_page()
            
          conf = PageConfig(
            *Path(".").glob("*.yml")    # all .yml files in this folder
          ).with_playwright_page(page)

          page.goto("http://localhost:8000")
          conf.next_page("login")
          conf.element("username").fill("myusername")
          conf.element("password").fill("mypassword")
          conf.element("ok").click()
            
          page.next_page("dashboard")
          expect(conf.element("message")).to_be_visible()
