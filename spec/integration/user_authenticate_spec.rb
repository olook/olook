# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'integration/helpers'

feature "User Authenticate", %q{
  In order to give a full access
  As a user
  I want to authenticate using my Facebook account or a normal register
} do

  before :each do
    @user = Factory(:user)
    User.any_instance.stub(:counts_and_write_points)
  end

  scenario "User can fill the cpf when invited" do
    answer_survey
    visit accept_invitation_path(@user.invite_token)
    visit accept_invitation_path(:invite_token => @user.invite_token)
    page.should have_content("CPF")
  end

  scenario "User cant't fill the cpf when not invited" do
    answer_survey
    visit new_user_registration_path
    page.should_not have_content("CPF")
  end

  scenario "User Log in with facebook" do
    answer_survey
    visit "/users/auth/facebook"
    page.should have_content(I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook")
  end

  scenario "User Sign up" do
    answer_survey
    visit new_user_registration_path
    within("#user_new") do
      fill_in "user_first_name", :with => "First Name"
      fill_in "user_last_name", :with => "Last Name"
      fill_in "user_email", :with => "fake@mail.com"
      fill_in "user_password", :with => "123456"
      fill_in "user_password_confirmation", :with => "123456"
      click_button "Cadastrar"
    end
    page.should have_content(I18n.t "devise.registrations.signed_up")
  end

  scenario "User update without password" do
    do_login!(@user)
    visit edit_user_registration_path
    within("#user_edit") do
      fill_in "user_first_name", :with => "New First Name"
      fill_in "user_last_name", :with => "New Last Name"
      fill_in "user_email", :with => "fake@mail.com"
      click_button "Update"
    end
    page.should have_content(I18n.t "devise.registrations.updated")
  end

  scenario "User update with password" do
    do_login!(@user)
    visit edit_user_registration_path
    within("#user_edit") do
      fill_in "user_first_name", :with => "New First Name"
      fill_in "user_last_name", :with => "New Last Name"
      fill_in "user_email", :with => "fake@mail.com"
      fill_in "user_password", :with => "123456"
      fill_in "user_password_confirmation", :with => "123456"
      click_button "Update"
    end
    page.should have_content(I18n.t "devise.registrations.updated")
  end

  scenario "User Log in" do
    visit new_user_session_path
    fill_in "user_email", :with => @user.email
    fill_in "user_password", :with => @user.password
    click_button "Sign in"
    page.should have_content(I18n.t "devise.sessions.signed_in")
  end

  scenario "Whole sign up, sign out and sign in process" do
    login = "john@doe.com"
    pass = "123abc"

    answer_survey
    visit new_user_registration_path
    within("#user_new") do
      fill_in "user_first_name", :with => "First Name"
      fill_in "user_last_name", :with => "Last Name"
      fill_in "user_email", :with => login
      fill_in "user_password", :with => pass
      fill_in "user_password_confirmation", :with => pass
      click_on "Cadastrar"
    end
    page.should have_content(I18n.t "devise.registrations.signed_up")
    click_on "Logout"
    page.should have_content(I18n.t "devise.sessions.signed_out")

    visit new_user_session_path
    fill_in "user_email", :with => login
    fill_in "user_password", :with => pass
    click_button "Sign in"
    page.should have_content(I18n.t "devise.sessions.signed_in")
  end
end
