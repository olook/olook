class AddFantasyNameOnUsers < ActiveRecord::Migration
  def change
    add_column :users, :fantasy_name, :string
  end
end
