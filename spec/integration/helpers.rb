# -*- encoding : utf-8 -*-
def do_login!(user)
  visit new_user_session_path
  fill_in "user_email", :with => user.email
  fill_in "user_password", :with => user.password
  click_button "Sign in"
end

def answer_survey
  build_survey
  visit root_path
  click_link "Comece aqui. É grátis"
  choose "questions[question_#{Question.first.id}]"
  select('10', :from => 'day')
  select('10', :from => 'month')
  select('1900', :from => 'year')
  click_button "Enviar"
end

def build_survey
  6.times do
    @question = FactoryGirl.create(:question)
    @answer = FactoryGirl.create(:answer_from_casual_profile, :question => @question)
  end
end
