class AddAbacosStatusToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :erp_integrate_at, :datetime
    add_column :orders, :erp_cancel_at, :datetime
    add_column :orders, :erp_payment_at, :datetime
    add_column :orders, :erp_integrate_error, :string
    add_column :orders, :erp_cancel_error, :string
    add_column :orders, :erp_payment_error, :string
  end
end