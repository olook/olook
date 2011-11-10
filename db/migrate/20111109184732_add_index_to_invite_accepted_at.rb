class AddIndexToInviteAcceptedAt < ActiveRecord::Migration
  def change
    add_index :invites, :accepted_at
  end
end
