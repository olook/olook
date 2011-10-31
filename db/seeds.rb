# -*- encoding : utf-8 -*-
[Admin, Profile, Question, Answer, Weight, SurveyAnswer].map(&:delete_all)

Admin.create(:email => "admin@olook.com", :password =>"123456")

survey = Survey.new(SURVEY_DATA).build

