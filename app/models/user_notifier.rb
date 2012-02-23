# -*- encoding : utf-8 -*-
class UserNotifier
  
  def self.get_orders ( status, how_long, range, validators=[] )

    time = Time.now.beginning_of_day
    from = time - days_to_s( how_long + range )
    to = time - days_to_s( how_long )

    validators << "state = '#{status}'"
    validators << "updated_at >= '#{from}'"
    validators << "updated_at <= '#{to}'"

  end

  def self.send_in_cart ( conditions )
    Order.find_each(:conditions => conditions) do |order|
      order.user.reset_authentication_token!
      order.update_attribute("in_cart_notified", true)

      products = []
      order.line_items.each do |product|
        if product.variant.inventory != 0
          products << product
        end
      end

      InCartMailer.send_in_cart_mail( order, products ).deliver unless products.empty?
    end
    
  end

  def self.delete_old_orders ( conditions )
    Order.find_each(:conditions => conditions) do |order|
      order.destroy
    end
    
  end

  private

  def self.days_to_s ( days )
    seconds = days * 24 * 60 * 60
  end

end