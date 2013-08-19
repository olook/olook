class AddUserDataToUserInfo < ActiveRecord::Migration
  def change
    add_column :user_infos, :dress_size, :string
    add_column :user_infos, :t_shirt_size, :string
    add_column :user_infos, :pants_size, :string
  end
end
