class AddFacebookDataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_data, :text
  end
end
