class AddProfileToUsers < ActiveRecord::Migration
  def change
    change_table :users, bulk: true do |t|
      t.string :profile
      t.string :wys_uuid
      t.string :state
      t.string :city
    end
    add_index :users, :half_user
  end
end
