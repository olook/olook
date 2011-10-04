class AddUidAndFacebookTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uid, :string
    add_column :users, :facebook_token, :text
    add_index :users, :uid
  end
end
