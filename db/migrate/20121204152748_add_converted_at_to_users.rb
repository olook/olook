class AddConvertedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :converted_at, :datetime, :null => true

  end
end
