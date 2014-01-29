# -*- encoding : utf-8 -*-

# logs-in user through js dropdown at the top of the interface
def do_login!(user)
  FacebookAdapter.any_instance.stub(:facebook_friends_registered_at_olook).and_return([])
  VCR.use_cassette('yahoo_login', :match_requests_on => [:host, :path]) do
    visit '/conta/sign_in'
    within('#sign-in-box') do
      fill_in "user_email", :with => user.email
      fill_in "user_password", :with => user.password
      click_button "login"
    end
  end
end

def do_admin_login!(admin)
  visit "/admin"
  fill_in "admin_email", :with => admin.email
  fill_in "admin_password", :with => admin.password
  within('form#new_admin') do
    click_button "Sign in"
  end
end

def answer_survey
  build_survey
  visit root_path
  click_link "Comece aqui. É grátis!"
  all("input[type=radio][name='questions[question_#{Question.first.id}]']").first.set(true)
  select('10', :from => 'day')
  select('Setembro', :from => 'month')
  select('1900', :from => 'year')
  find("input#finish").click
end

def build_survey
  survey = SurveyBuilder.new(SURVEY_DATA, "Registration Survey")
  survey.build
end
