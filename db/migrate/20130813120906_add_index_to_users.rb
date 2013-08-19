class AddIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :half_user
  end
end
