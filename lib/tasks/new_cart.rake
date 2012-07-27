# -*- encoding: utf-8 -*-
desc "New cart model"
namespace :new_cart do
  desc "Export orders that are in_the_cart to the cart model"
  task :in_the_cart_to_cart => :environment do
    Order.where(state: "IN_THE_CART").each do |order|
      # ORDERS
      # t.integer  "user_id"
      # t.datetime "created_at"
      # t.datetime "updated_at"
      # t.decimal  "credits",                          :precision => 8, :scale => 2, :default => 0.0
      # t.string   "state"
      # t.integer  "number",              :limit => 8
      # t.string   "identification_code"
      # t.string   "invoice_number"
      # t.string   "invoice_serie"
      # t.integer  "in_cart_notified",                                               :default => 0
      # t.boolean  "disable",                                                        :default => false
      # t.boolean  "gift_wrap",                                                      :default => false
      # t.string   "gift_message"
      # t.boolean  "restricted",                                                     :default => false, :null => false
      # t.datetime "purchased_at"
      # t.string   "state_reason"
      # t.integer  "cart_id"
      # t.decimal  "amount",                           :precision => 8, :scale => 2, :default => 0.0,   :null => false
      # t.decimal  "amount_discount",                  :precision => 8, :scale => 2, :default => 0.0,   :null => false
      # t.decimal  "amount_increase",                  :precision => 8, :scale => 2, :default => 0.0,   :null => false
      # t.decimal  "amount_paid",                      :precision => 8, :scale => 2, :default => 0.0,   :null => false
      # t.decimal  "subtotal",                         :precision => 8, :scale => 2, :default => 0.0,   :null => false

      # CARTS
      # t.integer  "user_id"
      # t.boolean  "notified",   :default => false, :null => false
      # t.datetime "created_at",                    :null => false
      # t.datetime "updated_at",                    :null => false
      cart = Cart.create!(
        legacy_id: order.id,
        user_id: order.user_id,
        notified: order.in_cart_notified,
        created_at: order.created_at,
        updated_at: order.updated_at
      )

      # LINE ITEMS
      # t.integer "variant_id"
      # t.integer "order_id"
      # t.integer "quantity"
      # t.decimal "price",        :precision => 8, :scale => 3
      # t.boolean "gift"
      # t.decimal "retail_price", :precision => 8, :scale => 3

      # CART ITEMS
      # t.integer "variant_id",                                                       :null => false
      # t.integer "cart_id",                                                          :null => false
      # t.integer "quantity",                                      :default => 1,     :null => false
      # t.integer "gift_position",                                 :default => 0,     :null => false
      # t.boolean "gift",                                          :default => false, :null => false
      # t.decimal "price",           :precision => 8, :scale => 2, :default => 0.0,   :null => false
      # t.decimal "retail_price",    :precision => 8, :scale => 2, :default => 0.0,   :null => false
      # t.decimal "discount",        :precision => 8, :scale => 2, :default => 0.0,   :null => false
      # t.string  "discount_source",                                                  :null => false
      if cart
        puts cart.inspect
        order.line_items.each do |li|
          ci = CartItem.create!(
            cart_id: cart.id,
            variant_id: li.variant_id,
            quantity: li.quantity,
            price: li.price,
            retail_price: li.retail_price,
            discount_source: 'legacy',
            gift: li.gift ? true : false
          )
          if ci
            puts ci.inspect
          else
            puts ci.errors.join("\n")
          end
        end

        # destroy the order
        order.destroy
      else
        puts cart.errors.join("\n")
      end

      break
    end
  end
end