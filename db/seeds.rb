# -*- encoding : utf-8 -*-
[Admin, Profile, Question, Answer, Weight, SurveyAnswer].map(&:delete_all)

Admin.create(:email => "admin@olook.com", :password =>"123456", :first_name => "administrator", :last_name => "olook")
Role.create(:name => "superadministrator", :description => "Manages the whole system")

survey = Survey.new(SURVEY_DATA).build

