# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "User Authenticate", %q{
  In order to give a full access
  As a user
  I want to authenticate using my Facebook account or a normal register
} do
# , vcr: {cassette_name: 'yahoo', :match_requests_on => [:host, :path]}

  pending "The flow has changed. Update the spec"

  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => "invite") }

  # def showroom_message
  #   "Sua stylist está criando sua vitrine personalizada, ela ficará pronta em 24 horas"
  # end

  def update_user_to_old_user(login)
    user = User.find_by_email(login)
    user.created_at = Time.now - 1.day
    user.record_first_visit
  end

  let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, :code => :loyalty_program) }
  let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, :code => :invite) }
  let!(:redeem_credit_type) { FactoryGirl.create(:redeem_credit_type, :code => :redeem) }

  before :each do
    FacebookAdapter.any_instance.stub(:facebook_friends_registered_at_olook).and_return([])
    @user = FactoryGirl.create(:user)
    User.any_instance.stub(:counts_and_write_points)
  end

  scenario "User must fill the cpf when invited" do
    pending "The flow has changed. Update the spec"
    visit accept_invitation_path(:invite_token => @user.invite_token)
    answer_survey
    page.should have_content("CPF")
  end

  scenario "User can't fill the cpf when not invited" do
    pending "The flow has changed. Update the spec"
    answer_survey
    visit new_user_registration_path
    page.should_not have_content("CPF")
  end

  scenario "User Log in with facebook" do
    pending "The flow has changed. Update the spec"
    answer_survey
    click_on 'Sign in with Facebook'
    within("#new_user") do
      fill_in "user_password", :with => "123456"
      fill_in "user_password_confirmation", :with => "123456"
      click_button "register"
    end
   # within("#welcome") do
   #   page.should have_content(showroom_message)
   # end
  end

  scenario "User Sign up" do
    pending "The flow has changed. Update the spec"
    answer_survey
    visit new_user_registration_path
    within("#new_user") do
      fill_in "user_first_name", :with => "First Name"
      fill_in "user_last_name", :with => "Last Name"
      fill_in "user_email", :with => "fake@mail.com"
      fill_in "user_password", :with => "123456"
      fill_in "user_password_confirmation", :with => "123456"
      click_button "register"
    end
    # within("#welcome") do
    #    page.should have_content(showroom_message)
    # end
  end

  scenario "Invited User Sign up earns R$ 10,00 worth of credit after registration" do
    pending "The flow has changed. Update the spec"
    visit accept_invitation_path(:invite_token => @user.invite_token)
    answer_survey
    visit new_user_registration_path
    within("#new_user") do
      fill_in "user_first_name", :with => "Senhor"
      fill_in "user_last_name", :with => "Madroga"
      fill_in "user_email", :with => "madruguinha@mail.com"
      fill_in "user_password", :with => "123456bola"
      fill_in "user_password_confirmation", :with => "123456bola"
      fill_in "user_cpf", :with => "214.872.785-00"

      click_button "register"
      visit(member_invite_path)
    end

    within(".amount") do
      page.should have_content("R$ 10,00")
    end
  end

  scenario "User update without password" do
    pending "The flow has changed. Update the spec"
    do_login!(@user)
    visit edit_user_registration_path
    within("#edit_user") do
      fill_in "user_first_name", :with => "New First Name"
      fill_in "user_last_name", :with => "New Last Name"
      fill_in "user_email", :with => "fake@mail.com"
      click_button "update_user"
    end
    within('#info_user') do
     page.should have_content("New First Name")
    end
  end

  scenario "User update with password" do
    pending "The flow has changed. Update the spec"
    do_login!(@user)
    visit edit_user_registration_path
    within("#edit_user") do
      fill_in "user_first_name", :with => "New First Name"
      fill_in "user_last_name", :with => "New Last Name"
      fill_in "user_email", :with => "fake@mail.com"
      fill_in "user_password", :with => "123456"
      fill_in "user_cpf", :with => "19762003601"
      fill_in "user_password_confirmation", :with => "123456"
      click_button "update_user"
    end
    within('#info_user') do
     page.should have_content("New First Name")
    end
  end

  scenario "User Log in" do
    pending "The flow has changed. Update the spec"
    visit new_user_session_path
    # login through js pulldown
    within('div#session') do
      fill_in "user_email", :with => @user.email
      fill_in "user_password", :with => @user.password
      click_button "login"
      page.should have_content(I18n.t "devise.sessions.signed_in")
    end
  end

  scenario "Sign up with invalid birthdate" do
    pending "The flow has changed. Update the spec"
    build_survey
    visit root_path
    click_link "Comece aqui. É grátis!"
    all("input[type=radio][name='questions[question_#{Question.first.id}]']").first.set(true)
    select('30', :from => 'day')
    select('Fevereiro', :from => 'month')
    select('1990', :from => 'year')
    within("input#finish") do
     page.should have_xpath("//input[@disabled='disabled']")
    end
  end

  scenario "Whole sign up, sign out and sign in process" do
    login = "john@doe.com"
    pass = "123abc"
  pending "The flow has changed. Update the spec"

    answer_survey
    visit new_user_registration_path
    within("#new_user") do
      fill_in "user_first_name", :with => "First Name"
      fill_in "user_last_name", :with => "Last Name"
      fill_in "user_email", :with => login
      fill_in "user_password", :with => pass
      fill_in "user_password_confirmation", :with => pass
      click_on "register"
    end
    # page.should have_content(showroom_message)
    click_on "Sair"
    page.should have_content(I18n.t "devise.sessions.signed_out")

    update_user_to_old_user(login)

    visit new_user_session_path
    # login through main content form on login page
    within('div#content') do
      fill_in "user_email", :with => login
      fill_in "user_password", :with => pass
      click_button "login"
    end
    within(".notice") do
      page.should have_content(I18n.t "devise.sessions.signed_in")
    end
  end
end
