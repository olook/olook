require 'spec_helper'

feature "User Authenticate", %q{
  In order to see give a full access
  As a user
  I want to authenticate
} do

  before :each do
    @user = Factory(:user)
  end

  scenario "User Log in" do
    visit new_user_session_path
    fill_in "user_email", :with => @user.email
    fill_in "user_password", :with => @user.password
    click_button "Sign in"
    page.should have_content(I18n.t "devise.sessions.signed_in")
  end

  scenario "User Log in with facebook" do
    visit root_path
    click_link "Sign in with Facebook"
    page.should have_content(I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook")
  end
end
