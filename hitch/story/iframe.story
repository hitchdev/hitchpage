Iframe:
  based on: setup
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

  steps:
  - Run:
      code: |
        conf.next_page("iframe")
        print("iframe page")
        expect(conf.element("iframe page title")).to_be_visible()
        expect(conf.element("iframe content message")).to_be_visible()

      will output: |-
        iframe page


