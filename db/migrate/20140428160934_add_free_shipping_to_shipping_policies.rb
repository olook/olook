class AddFreeShippingToShippingPolicies < ActiveRecord::Migration
  def change
    add_column :shipping_policies, :free_shipping, :string
  end
end
