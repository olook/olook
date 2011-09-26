require 'spec_helper'

feature "User Authenticate", %q{
  In order to see give a full access
  As a user
  I want to authenticate
} do

  scenario "User Log in" do
    @user = Factory(:user)
    visit new_user_session_path
    fill_in "user_email", :with => @user.email
    fill_in "user_password", :with => @user.password
    click_button "Sign in"
    page.should have_content(I18n.t "devise.sessions.signed_in")
  end
end
