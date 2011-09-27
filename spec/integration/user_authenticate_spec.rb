require 'spec_helper'

feature "User Authenticate", %q{
  In order to give a full access
  As a user
  I want to authenticate using my Facebook account or a normal register
} do

  before :each do
    @user = Factory(:user)
    User.any_instance.stub(:counts_and_write_points)
    @answer = Factory.create(:answer_from_casual_profile)
    @question = @answer.question
  end

  scenario "User Sign up" do
    visit root_path
    click_link "Take the Style Quiz"
    choose "questions[question_#{@question.id}]" 
    click_button "Enviar"
    visit new_user_registration_path
    fill_in "user_name", :with => "User Name"
    fill_in "user_email", :with => "fake@mail.com"
    fill_in "user_password", :with => "123456"
    fill_in "user_password_confirmation", :with => "123456"
    click_button "Sign up"
    page.should have_content(I18n.t "devise.registrations.signed_up")
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
    click_link "Take the Style Quiz"
    choose "questions[question_#{@question.id}]"
    click_button "Enviar"
    visit "/users/auth/facebook"
    page.should have_content(I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook")
  end

  scenario "User Sign up with facebook" do
    User.delete_all
    visit root_path
    click_link "Take the Style Quiz"
    choose "questions[question_#{@question.id}]"
    click_button "Enviar"
    visit "/users/auth/facebook"
    page.should have_content(I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook")
  end
end
