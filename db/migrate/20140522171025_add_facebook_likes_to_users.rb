class AddFacebookLikesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_likes, :text
  end
end
