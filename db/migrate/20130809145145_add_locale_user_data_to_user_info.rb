class AddLocaleUserDataToUserInfo < ActiveRecord::Migration
  def change
    add_column :user_infos, :state, :string
    add_column :user_infos, :city, :string
  end
end
