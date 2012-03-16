# -*- encoding : utf-8 -*-
admin = Admin.new(:email => "admin@olook.com",
                  :password =>"DifficultPassword123",
                  :first_name => "administrator",
                  :last_name => "olook")
admin.role = superadmin
admin.save!

survey = Survey.new(SURVEY_DATA).build
