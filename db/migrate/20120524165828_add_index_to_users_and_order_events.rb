class AddIndexToUsersAndOrderEvents < ActiveRecord::Migration
  def change
    add_index :users, :authentication_token
    add_index :users, :reset_password_token
    add_index :users, :created_at
    add_index :order_events, :order_id
  end
end
