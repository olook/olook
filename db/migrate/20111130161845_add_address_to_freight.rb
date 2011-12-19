class AddAddressToFreight < ActiveRecord::Migration
  def change
    add_column :freights, :address_id, :integer
  end
end
