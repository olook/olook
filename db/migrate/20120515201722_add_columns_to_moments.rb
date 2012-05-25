class AddColumnsToMoments < ActiveRecord::Migration
  def change
    add_column :moments, :article, :string, :limit => 25, :null => false
    add_column :moments, :position, :integer, :default => 1
  end
end
