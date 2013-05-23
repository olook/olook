class AddProducerCodeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :producer_code, :string
  end
end
