class RemoveCarrierFromShippings < ActiveRecord::Migration
  def up
    remove_column :shippings, :carrier
  end

  def down
    add_column :shippings, :carrier, :string
  end
end
