---
title: Quickstart
---



Simple scenario with a log in page and a dashboard
with some locator selectors and one text selector.


# Code Example


With code:

```python
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

```


selectors.yml:

```yaml
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
    
```

With HTML:

```html
{'index.html': '<div class="form-login">\n<input type="text" id="id_username" placeholder="username" /></br>\n<input type="text" id="id_password" placeholder="password" /></br>\n<div class="wrapper">\n<span class="group-btn">     \n<a id="id_ok_button" href="/dashboard.html" class="btn btn-primary btn-md">login <i class="fa fa-sign-in"></i></a>\n</span>\n</div>\n</div>\n', 'dashboard.html': '<div class="form-login">\n  <h4 id="id_this_is_a_dashboard_element">Dashboard</h4>\n  <p id="id_dashboard_message">hello!</a>\n</div>\n'}
```






```python
conf.next_page("login")
print("login page")
conf.element("username").fill("myusername")
conf.element("password").fill("mypassword")
conf.element("ok").click()
  
conf.next_page("dashboard")
print("dashboard page")
expect(conf.element("message")).to_be_visible()

```

Will output:
```
login page                                                                                                                                                      
dashboard page
```









!!! note "Executable specification"

    Documentation automatically generated from 
    <a href="https://github.com/hitchdev/hitchpage/blob/master/hitch/story/quickstart.story">quickstart.story
    storytests.</a>

