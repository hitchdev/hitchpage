---
title: Reload
---
# Reload




Reload the selectors mid run based upon a file change.

This is useful for debugging and writing in new selectors
mid test run.


## Code Example


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
```
new_selectors_file.txt:

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


index.html:

```html
<div class="form-login">
<input type="text" id="id_username" placeholder="username" /></br>
<input type="text" id="id_password" placeholder="password" /></br>
<div class="wrapper">
<span class="group-btn">     
<a id="id_ok_button" href="/dashboard.html" class="btn btn-primary btn-md">login <i class="fa fa-sign-in"></i></a>
</span>
</div>
</div>

```

dashboard.html:

```html
<div class="form-login">
  <h4 id="id_this_is_a_dashboard_element">Dashboard</h4>
  <p id="id_dashboard_message">hello!</a>
</div>

```







```python
conf.next_page("login")
print("login page")
conf.element("username").fill("myusername")
conf.element("password").fill("mypassword")
conf.element("ok").click()

# overwrite the YAML file so it can be reloaded
import shutil
shutil.copyfile("new_selectors_file.txt", "selectors.yml")
conf.reload_config()
  
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
    <a href="https://github.com/hitchdev/hitchpage/blob/master/hitch/story/reload.story">reload.story
    storytests.</a>

