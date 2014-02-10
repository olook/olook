class CreateLooks < ActiveRecord::Migration
  def change
    create_table :looks do |t|
      t.integer :product_id
      t.string :picture
      t.datetime :launched_at
      t.integer :profile_id

      t.timestamps
    end
  end
end
