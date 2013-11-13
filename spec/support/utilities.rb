def sign_in(display)
  visit signin_path
  fill_in "Name",    with: display.name
  fill_in "Password", with: display.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = display.remember_token
end

