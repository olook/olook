# -*- encoding: utf-8 -*-
desc "New cart model"
namespace :new_cart do
  desc "Export orders that are in_the_cart to the cart model"
  task :in_the_cart_to_cart => :environment do
    Order.where(state: "IN_THE_CART").each do |order|
      cart = Cart.create!(
        legacy_id: order.id,
        user_id: order.user_id,
        notified: order.in_cart_notified,
        created_at: order.created_at,
        updated_at: order.updated_at
      )

      if cart
        order.line_items.each do |li|
          ci = CartItem.create!(
            cart_id: cart.id,
            variant_id: li.variant_id,
            quantity: li.quantity,
            gift: li.gift ? true : false
          )
        end

        # destroy the order
        order.destroy
      end
    end
  end
  
  desc "Consolidate order value"
  task :consolidate_order => :environment do |t, args|
    filename = ENV['filename']
    col_sep = ENV['col_sep']
    founds = 0
    not_founds = 0
    updateds = 0
    csv = CSV.read(filename, {:headers => true,  :header_converters => :symbol , :col_sep => col_sep, encoding: "UTF-8"})
    csv.each do |row|
      begin
        next if "VENDA DE PRODUTOS" != row[11]
        order_number = row[0]
        order = Order.find_by_number(order_number)
        if  order.nil?
          not_founds += 1
          next
        end

        subtotal = BigDecimal.new(row[2], 2)
        total_discount = BigDecimal.new(row[3], 2)
        amount_paid = BigDecimal.new(row[4], 2)
        amount_increase = BigDecimal.new(row[5], 2) + (order.gift_wrap? ? 5 : 0)
        
        founds += 1
        if (order.subtotal.nil? || order.subtotal == 0)
          order.update_attributes({
            :subtotal => subtotal,
            :amount_discount => total_discount,
            :amount_paid => amount_paid,
            :amount_increase => amount_increase
          })
          updateds += 1
        end
      rescue Exception => e
        not_founds += 1
        
        puts "Order not found: #{e.message}"
      end
    end
    puts "Order founds: #{founds}\n"
    puts "Order updateds: #{updateds}\n"
    puts "Order Not founds: #{not_founds}\n"
  end
end