class CreateSurveyAnswers < ActiveRecord::Migration
  def change
    create_table :survey_answers do |t|
      t.integer :user_id
      t.text :answers

      t.timestamps
    end
  end
end
