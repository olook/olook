class AddWysUuidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wys_uuid, :string
  end
end
