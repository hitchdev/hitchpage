---
title: Iframe
---
# Iframe




Look for an element inside an iframe.

Then look for an element inside an iframe inside an iframe.


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
iframe:
  element:
    page title: "#id_iframe_title"
    message iframe:
      locator: "#message_iframe"
    iframe content message:
      in iframe: message iframe
      locator: "#id_dashboard_message"
    iframe in iframe:
      in iframe: message iframe
      locator: iframe
    iframe in iframe message:
      in iframe: iframe in iframe
      locator: "#id_iframe_in_iframe"
    
```

With HTML:


index.html:

```html
<div class="form-login">
  <h4 id="id_iframe_title">This page contains an iframe</h4>
  <iframe id="message_iframe" src="iframe_content.html" />
</div>

```

iframe_content.html:

```html
<p id="id_dashboard_message">hello!</a>
<iframe id="child_iframe" src="iframe_in_iframe_content.html" />

```

iframe_in_iframe_content.html:

```html
<p id="id_iframe_in_iframe">message</a>

```







```python
conf.next_page("iframe")
print("iframe page")
expect(conf.element("page title")).to_be_visible()
expect(conf.element("iframe content message")).to_be_visible()
expect(conf.element("iframe in iframe message")).to_be_visible()

```

Will output:
```
iframe page
```









!!! note "Executable specification"

    Documentation automatically generated from 
    <a href="https://github.com/hitchdev/hitchpage/blob/master/hitch/story/iframe.story">iframe.story
    storytests.</a>

