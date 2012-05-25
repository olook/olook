# -*- encoding : utf-8 -*-
superadmin = Role.create(:name => "superadministrator", :description => "Manages the whole system")

admin = Admin.new(:email => "admin@olook.com",
                  :password =>"DifficultPassword123",
                  :first_name => "administrator",
                  :last_name => "olook")
admin.role = superadmin
admin.save!

survey = SurveyBuilder.new(SURVEY_DATA, "Registration Survey").build
