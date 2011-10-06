class CreateWeights < ActiveRecord::Migration
  def change
    create_table :weights do |t|
      t.integer :profile_id
      t.integer :answer_id
      t.integer :weight
    end
  end
end
