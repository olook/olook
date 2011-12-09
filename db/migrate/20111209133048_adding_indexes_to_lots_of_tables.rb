class AddingIndexesToLotsOfTables < ActiveRecord::Migration
  def change
    add_index :weights, :profile_id
    add_index :weights, :answer_id
    
    add_index :variants, :number
    
    add_index :profiles, :name
    
    add_index :products_profiles, :product_id
    add_index :products_profiles, :profile_id
    
    add_index :products, :model_number
    
    add_index :points, :profile_id
    
    add_index :payments, :order_id

    add_index :payment_responses, :payment_id
    
    add_index :orders, :user_id
    
    add_index :line_items, :variant_id
    add_index :line_items, :order_id
    
    add_index :freights, :order_id
    
    add_index :details, :product_id
    
    add_index :addresses, :user_id
  end
end
