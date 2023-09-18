---
title: Page Config Model
---
# Page Config Model

The page config model is a version of the [page object model](https://martinfowler.com/bliki/PageObject.html) design pattern.

A page config object wraps an HTML page or fragment, with an application-specific API, allowing you to manipulate page elements without digging around in the HTML.

The main difference is that the PCM uses **configuration not code** to abstract selectors. This is done according to [the rule of least power](https://en.wikipedia.org/wiki/Rule_of_least_power).

Example:

```python
pcm.next_page("login")
pcm.element("username").fill("myusername")
pcm.element("password").fill("mypassword")
pcm.element("ok").click()
pcm.next_page("dashboard") expect(pcm.element("message")).to_be_visible()
```

With a corresponding page config:

```yaml
login:
  element:
    username: "#id_username"
    password: "#id_password"
    ok: "#id_ok_button"
dashboard:
   element:
     message: "#id_dashboard_message"
```

The page config model is a pattern exhibited by hitchpage, which was designed to be used with the hitchstory testing and documentation framework.

This is so that developers can write declarative, testable specification scenarios that are complely decoupled from selectors and are thus readable and executable. For example:

```yaml
- enter:
    username: myusername
    password: mypassword
- click: ok
- new page: dashboard
- expect: message
```

Unlike the page object model, the page config model pattern is currently built upon the assumption that, by default, granular interactions - e.g. clicking buttons, filling text boxes are *all* parts of the spec which are of potential interest to stakeholders and should therefore not be abstracted by default.

