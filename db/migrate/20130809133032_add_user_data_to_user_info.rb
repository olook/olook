class AddUserDataToUserInfo < ActiveRecord::Migration
  def change
    change_table :user_infos, bulk: true do |t|
      t.string :dress_size
      t.string :t_shirt_size
      t.string :pants_size
    end
  end
end
