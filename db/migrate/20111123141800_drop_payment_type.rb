class DropPaymentType < ActiveRecord::Migration
  def up
    remove_column :payments, :payment_type
  end

  def down
    add_column :payments, :payment_type, :integer
  end
end
