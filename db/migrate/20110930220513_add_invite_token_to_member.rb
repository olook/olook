class AddInviteTokenToMember < ActiveRecord::Migration
  def change
    add_column :users, :invite_token, :string
    add_index :users, :invite_token
  end
end
