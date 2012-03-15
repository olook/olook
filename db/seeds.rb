# -*- encoding : utf-8 -*-
[Admin, Profile, Question, Answer, Weight, SurveyAnswer].map(&:delete_all)

superadmin = Role.create(:name => "superadministrator", :description => "Manages the whole system")
Admin.create(:email => "admin@olook.com", :password =>"123456", :first_name => "administrator", :last_name => "olook", :role_id => superadmin.id)

survey = Survey.new(SURVEY_DATA).build
