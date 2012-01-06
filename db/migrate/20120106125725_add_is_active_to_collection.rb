class AddIsActiveToCollection < ActiveRecord::Migration
  def change
    add_column :collections, :is_active, :boolean, :default => false
  end
end
