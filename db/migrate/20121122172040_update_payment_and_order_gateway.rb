class UpdatePaymentAndOrderGateway < ActiveRecord::Migration
  def up
    Payment.where(:gateway => nil).update_all(:gateway => 1)
    Order.where(:gateway => nil).update_all(:gateway => 1)
  end

  def down
  end
end
