class AddFacebookPermissionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_permissions, :string
    User.find_each do |user|
      if user.has_facebook_extended_permission
        user.facebook_permissions << "publish_stream"
        user.save
      end
    end
    #remove_column :users, :has_facebook_extended_permissions
  end
end
