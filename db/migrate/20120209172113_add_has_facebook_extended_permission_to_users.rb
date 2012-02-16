class AddHasFacebookExtendedPermissionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_facebook_extended_permission, :boolean
  end
end
