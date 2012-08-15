class ChangeToTextErpErrors < ActiveRecord::Migration
  def up
    change_column :orders, :erp_integrate_error, :text
    change_column :orders, :erp_cancel_error, :text
    change_column :orders, :erp_payment_error, :text
  end

  def down
    change_column :orders, :erp_integrate_error, :string
    change_column :orders, :erp_cancel_error, :string
    change_column :orders, :erp_payment_error, :string
  end
end