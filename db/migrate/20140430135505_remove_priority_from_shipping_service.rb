class RemovePriorityFromShippingService < ActiveRecord::Migration
  def up
    remove_column :shipping_services, :priority
  end

  def down
    add_column :shipping_services, :priority, :string
  end
end
