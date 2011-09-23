class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :title
      t.integer :question_id

      t.timestamps
    end
  end
end
