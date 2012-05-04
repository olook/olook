class CreateMoments < ActiveRecord::Migration
  def change
    create_table :moments do |t|
      t.integer :id
      t.string :name
      t.boolean :active, :default => false
      t.string :slug
      t.timestamps
    end
  end
end
