class AddCubicWeightFactorAndPriorityAndErpDeliveryServiceToShippingCompany < ActiveRecord::Migration
  def change
    add_column :shipping_companies, :cubic_weight_factor, :integer
    add_column :shipping_companies, :priority, :integer
    add_column :shipping_companies, :erp_delivery_service, :string
  end
end
