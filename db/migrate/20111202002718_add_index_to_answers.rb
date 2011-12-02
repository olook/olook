class AddIndexToAnswers < ActiveRecord::Migration
  def change
    add_index :survey_answers, :user_id
  end
end
