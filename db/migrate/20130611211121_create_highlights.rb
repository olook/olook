class CreateHighlights < ActiveRecord::Migration
  def change
    create_table :highlights do |t|
      t.string :link 
      t.string :image
      t.integer :position

      t.timestamps
    end
  end
end
