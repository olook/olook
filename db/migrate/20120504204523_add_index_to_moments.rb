class AddIndexToMoments < ActiveRecord::Migration
  def change
    add_index :moments, :name, :unique => true
    add_index :moments, :slug, :unique => true
  end
end
