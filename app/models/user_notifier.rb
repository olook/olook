# -*- encoding : utf-8 -*-
class UserNotifier

  def self.get_carts ( how_long, range, validators=[] )

    time = Time.now.beginning_of_day
    from = time - days_to_s( how_long + range )
    to = time - days_to_s( how_long )

    validators << "carts.updated_at >= '#{from}'"
    validators << "carts.updated_at <= '#{to}'"
    validators << "carts.user_id is not null"
  end

  def self.send_in_cart ( conditions )
     Cart.includes(:orders).where(:orders => {:id => nil}).find_each(:conditions => conditions) do |cart|
      cart.update_attribute("notified", true)

      products = []
      cart.items.each do |product|
        if product.variant.inventory != 0
          products << product
        end
      end

      InCartMailer.send_in_cart_mail( cart, products ).deliver unless products.empty?
    end

  end

  private

  def self.days_to_s ( days )
    seconds = days * 24 * 60 * 60
  end

end
