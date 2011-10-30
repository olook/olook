class AddIndexToInviteEmail < ActiveRecord::Migration
  def change
    add_index :invites, :email
  end
end
