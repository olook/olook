class AddUserToSyncronizationEvent < ActiveRecord::Migration
  def change
    add_column :synchronization_events, :user, :string
  end
end
