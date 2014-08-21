class RemoveResellerFromUsers < ActiveRecord::Migration
  def up
  	remove_column :users, :reseller
  	remove_column :users, :active
  end

  def down
  end
end
