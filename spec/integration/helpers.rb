# -*- encoding : utf-8 -*-

def do_login!(user)
  FacebookAdapter.any_instance.stub(:facebook_friends_registered_at_olook).and_return([])
  VCR.use_cassette('yahoo_login', :match_requests_on => [:host, :path]) do
    visit new_user_session_path
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => user.password
    click_button "login"
  end  
end

def do_admin_login!(admin)
  visit new_admin_session_path
  fill_in "admin_email", :with => admin.email
  fill_in "admin_password", :with => admin.password
  within('form#admin_new') do
    click_button "login"  
  end
end

def answer_survey
  build_survey
  visit root_path
  click_link "Comece aqui e descubra seu estilo. É grátis"
  choose "questions[question_#{Question.first.id}]"
  select('10', :from => 'day')
  select('Setembro', :from => 'month')
  select('1900', :from => 'year')
  click_button "finish"
end

def build_survey
  survey = Survey.new(SURVEY_DATA)
  survey.build
end

private
