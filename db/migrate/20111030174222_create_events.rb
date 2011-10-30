class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user
      t.string :type
      t.text :description

      t.timestamps
    end
    add_index :events, :user_id
    add_index :events, :type
    add_index :events, :created_at
  end
end
