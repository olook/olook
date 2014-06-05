class RemoveCubicWeightFactorFromShippingService < ActiveRecord::Migration
  def up
    remove_column :shipping_services, :cubic_weight_factor
  end

  def down
    add_column :shipping_services, :cubic_weight_factor, :string
  end
end
