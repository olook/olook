class CreateSurveysRecords < ActiveRecord::Migration
  def up
    survey = Survey.create(:name => "Registration Survey")
    Question.update_all(:survey_id => survey.id) if survey
    Survey.create!(:name => "Gift Survey")
  end

  def down
    Survey.destroy_all
  end
end
