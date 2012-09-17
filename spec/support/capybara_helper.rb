def visit_and_login(url,user = create(:admin_user))
  visit url
  click_link 'login' if page.has_link?('login')
  login_admin_user(user)
end

def login_admin_user(user)
  within("#new_admin_user") do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end
end

def click_link_and_confirm(link)
  click_link(link)
  page.click_link("dialog_confirm") if page.has_link?("dialog_confirm")
end

def fill_in_tinymce(input_id,options)
  if has_css?("##{input_id}_ifr")
    page.execute_script("$('##{input_id}').tinymce().setContent('#{options[:with]}')")
    # TODO get the bottom code working instead of the above code
    #within_frame("#{input_id}_ifr") do
    #  page.driver.browser.switch_to.frame(0)
    #  editor = page.find_by_id('tinymce').native
    #  editor.send_keys(options[:with])
    #end
  else
    fill_in(input_id, options)
  end
end

def in_new_window
  if respond_to?(:within_window)
    if page.driver.browser.respond_to?(:window_handles)
      within_window(page.driver.browser.window_handles.last) do
        yield
      end
    else
      begin
        within_window('preview') do
          yield
        end
      rescue Capybara::NotSupportedByDriverError
        # TODO needs to be fixed on Webkit
      end
    end
  else
    yield
  end
end

module ViewCapybaraRendered

  def rendered
    # Using @rendered variable, which is set by the render-method.
    Capybara.string(@rendered)
  end

  def within(selector)
    yield rendered.find(selector)
  end

end