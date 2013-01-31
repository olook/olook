class AddAddressToCart < ActiveRecord::Migration
  def change
    add_column :carts, :address_id, :integer
    add_index :carts, :address_id

  end
end
