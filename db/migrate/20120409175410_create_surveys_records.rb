# -*- encoding : utf-8 -*-
class CreateSurveysRecords < ActiveRecord::Migration
  def up
    survey = Survey.find_or_create_by_name("Registration Survey")
    Question.update_all(:survey_id => survey.id) if survey
  end

  def down
    Survey.destroy_all
  end
end
