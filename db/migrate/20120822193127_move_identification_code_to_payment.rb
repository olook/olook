class MoveIdentificationCodeToPayment < ActiveRecord::Migration
  def up
    add_column :payments, :identification_code, :string
    add_index "payments", ["identification_code"]
    
    Order.find_each do |order|
      if order.payment
        order.payment.update_attribute(:identification_code, order.identification_code)
      end
    end
    
    remove_column :orders, :identification_code
  end

  def down
    add_column :orders, :identification_code, :string
    add_index "orders", ["identification_code"]
    
    Payment.find_each do |payment|
      if payment.order
        payment.order.update_attribute(:identification_code, payment.identification_code)
      end
    end
    

    remove_column :payments, :identification_code, :string
  end
end