def sign_in(display)
  visit signin_path
  fill_in "Name",    with: display.name
  fill_in "Password", with: display.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = display.remember_token
end

def sign_in_user (display, user)
  visit mobile_path(display.unique_id)
  #ENV["devise.mapping"] = Devise.mappings[:user] 
  OmniAuth.config.test_mode = true  
  OmniAuth.config.mock_auth[:facebook] = {
    'uid' => user.uid,
    'provider' => 'facebook',
    'credentials' => {'token' => user.token},
    'extra' => { 'raw_info' => { 'name' => user.name, 'email' => user.email } },
  }
  visit signinuser_path
  click_link "Sign in using Facebook"
end
