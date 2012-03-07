# -*- encoding : utf-8 -*-
namespace :olook do
  task :generate_billets_for_old_orders => :environment  do
    billet_table = Billet.arel_table
    pending_billets = Billet.where(billet_table[:state].eq("started").or(billet_table[:state].eq("billet_printed")))
    billet_generator = BilletGenerator.new(pending_billets)
    puts "#{billet_generator.generate} boleto(s) gerado(s) com sucesso"
  end

  task :generate_cart_links => :environment  do
    hash = YAML.load_file('order_ids.yaml')
    orders = hash["order_ids"].split(" ")
    CSV.open("links.csv", "wb") do |csv|
      csv << ["user_id", "email", "first_name", "last_name", "num_order", "date_of_order", "link_cart", "credit_card", "picture_1", "product_name_1", "price_1", "picture_2", "product_name2", "price_2", "picture_3", "product_name3", "price_3"]

        orders.each do |order_id|
        order = Order.find_by_id(order_id.to_i)
        if order
          card = order.payment.try(:bank)
          order.payment.destroy if order.payment
          order.update_attributes!(:state => "in_the_cart")
          order.generate_identification_code
          order.user.reset_authentication_token!
          order.update_attributes!(:in_cart_notified => true)
          coupon = Coupon.lock("LOCK IN SHARE MODE").find_by_id(order.used_coupon.try(:coupon_id))
          if coupon
            coupon.increment!(:remaining_amount, 1) unless coupon.unlimited?
          end
          auth_token = order.user.authentication_token
          host = Rails.env.development? ? "http://localhost:3000" : "http://www.olook.com.br"
          link = "#{host}/sacola?auth_token=#{auth_token}&order_id=#{order_id}"
          line = [order.user.id, order.user.email, order.user.first_name, order.user.last_name, order.number, order.created_at.strftime("%d/%m/%Y"), link, card]

          3.times do |i|
            if order.line_items[i]
              product = order.line_items[i].variant.product
              line.push product.send(image_method ||= :showroom_picture)
              line.push product.name
              line.push product.price
            end
          end
          csv << line
        end
      end
    end
  end
end
