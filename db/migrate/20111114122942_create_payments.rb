# -*- encoding : utf-8 -*-
class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :order_id
      t.integer :payment_type
      t.text :url
      t.timestamps
    end
  end
end
