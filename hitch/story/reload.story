Reload:
  based on: setup
  docs: reload
  about: |
    Reload the selectors mid run based upon a file change.
    
    This is useful for debugging and writing in new selectors
    mid test run.
  given:
    files:
      selectors.yml: |
        login:
          element:
            username: "#id_username"
            password: "#id_password"
            ok: "#id_ok_button"
      new_selectors_file.txt: |
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
            
    html:
      index.html: |
        <div class="form-login">
        <input type="text" id="id_username" placeholder="username" /></br>
        <input type="text" id="id_password" placeholder="password" /></br>
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
        </div>

  steps:
  - Run:
      code: |
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
      will output: |-
        login page                                                                                                                                                      
        dashboard page


