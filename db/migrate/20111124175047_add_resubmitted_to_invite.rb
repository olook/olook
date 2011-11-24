class AddResubmittedToInvite < ActiveRecord::Migration
  def change
    add_column :invites, :resubmitted, :boolean
  end
end
