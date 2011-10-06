# -*- encoding : utf-8 -*-
class AddFirstAndLastNameToUsers < ActiveRecord::Migration
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    remove_column :users, :name
  end

  def down
    rename_column :users, :first_name, :name
    remove_column :users, :last_name
  end
end
