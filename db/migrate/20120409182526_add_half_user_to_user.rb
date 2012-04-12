class AddHalfUserToUser < ActiveRecord::Migration
  def change
    add_column :users, :half_user, :boolean
  end
end
