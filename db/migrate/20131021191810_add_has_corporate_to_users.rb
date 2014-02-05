class AddHasCorporateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_corporate, :boolean
  end
end
