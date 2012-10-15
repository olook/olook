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
     file_lines = []
     # header
     file_lines << "email%nome%produtos%relacionados"

     Cart.includes(:orders).where(:orders => {:id => nil}).find_each(:conditions => conditions) do |cart|
      # cart.update_attribute("notified", true)
      products = []
      related_products = []

      cart.items.each do |product|
        p = product.variant.product
        if product.variant.inventory != 0
          products << product
          related_products |= p.related_products
        end
      end

      products = products.sample(3)
      related_products = related_products.sample(3)
      user = cart.user

      line = []
      line << user.email
      line << user.first_name

      line << format_cart_items(products)

      line << format_related_products(related_products)

      file_lines << line.join("%") unless products.empty?

      # Salvar .csv
      # InCartMailer.send_in_cart_mail( cart, products ).deliver unless products.empty?
    end
    file_lines
  end

  def self.send_enabled_credits_notification
    arr = []
    users_selected_by(:activates_at).find_each do |user|
      arr << LoyaltyProgramMailer.send_enabled_credits_notification(user)
    end
    arr
  end

  def self.send_expiration_warning(expires_tomorrow = false)
    date = DateTime.now.end_of_month
    arr = []
    users_selected_by(:expires_at, date).find_each do |user|
      response = LoyaltyProgramMailer.send_expiration_warning(user, expires_tomorrow)
      arr << response unless response.nil?
    end
    arr
  end

  def self.days_to_s ( days )
    seconds = days * 24 * 60 * 60
  end

  def self.users_selected_by(arel_field, date = DateTime.now)
    condition = Credit.arel_table[arel_field] 
    User.joins(user_credits: [:credit_type, :credits])
        .where(credit_types: {code: :loyalty_program})
        .where(condition.lteq(date +1.day))
        .where(condition.gteq(date -1.day))  
        .uniq  
  end

  private
  def format_cart_items cart_items
    cart_item_lines = []
    cart_items.each do |cart_item|
      cart_item_line = []
      cart_item_line << cart_item.variant.showroom_picture
      cart_item_line << cart_item.name
      cart_item_line << "#{('%.2f' % cart_item.variant.price).gsub('.',',')}"
      cart_item_line << cart_item.description
      cart_item_lines << cart_item_line.join("|")
    end
    cart_item_lines.join("#")
  end

  def format_related_products related_products
    related_product_lines = []
    related_products.each do |product|
      related_product_line = []
      related_product_line << product.master_variant.showroom_picture
      related_product_line << product.name
      related_product_line << "#{('%.2f' % product.master_variant.price).gsub('.',',')}"
      related_product_line << product.description
      related_product_lines << related_product_line.join("|")
    end
    related_product_lines.join("#")
  end

end
