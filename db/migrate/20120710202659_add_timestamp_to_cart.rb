class AddTimestampToCart < ActiveRecord::Migration
  def up
    change_table :carts do |t|
      t.timestamps
    end
  end

  def down
    remove_column :carts , :updated_at
    remove_column :carts , :created_at
  end
end
