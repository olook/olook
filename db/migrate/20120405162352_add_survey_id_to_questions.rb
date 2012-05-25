class AddSurveyIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :survey_id, :integer
  end
end
