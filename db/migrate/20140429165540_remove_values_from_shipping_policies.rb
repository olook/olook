class RemoveValuesFromShippingPolicies < ActiveRecord::Migration
  def up
    remove_column :shipping_policies, :value_start
    remove_column :shipping_policies, :value_end
  end

  def down
    add_column :shipping_policies, :value_end, :string
    add_column :shipping_policies, :value_start, :string
  end
end
