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
end