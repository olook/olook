# -*- encoding : utf-8 -*-
class UserNotifier

  def self.get_carts ( how_long, range, validators=[] )

    time = Time.now
    from = time - days_to_s( how_long + range )
    to = time - days_to_s( how_long )

    validators << "carts.updated_at >= '#{from}'"
    validators << "carts.updated_at <= '#{to}'"
    validators << "carts.user_id is not null"
  end

  def self.send_enabled_credits_notification
    raise 'Feature Deprecated'
    arr = []
    users_selected_by(:activates_at).find_each do |user|
      if !Setting.whitelisted_emails_only || user.email.match(/(olook\.com\.br$)/)
        response = LoyaltyProgramMailer.send_enabled_credits_notification(user)
        arr << response unless response.nil? || response.try(:from).nil?
      end
    end
    arr
  end

  def self.send_expiration_warning(expires_tomorrow = false)
    raise 'Feature Deprecated'
    date = DateTime.now.at_midnight + 7.days

    arr = []
    users_selected_by(:expires_at, date).find_each do |user|
      response = LoyaltyProgramMailer.send_expiration_warning(user, expires_tomorrow, date)
      arr << response unless response.nil?
    end
    arr
  end

  def self.days_to_s ( days )
    seconds = days * 24 * 60 * 60
  end

  def self.users_selected_by(arel_field, date = DateTime.now.at_midnight)
    condition = Credit.arel_table[arel_field]
    User.joins(user_credits: [:credit_type, :credits])
        .where(credit_types: {code: :loyalty_program})
        .where(condition.lteq(date + 12.hours))
        .where(condition.gteq(date - 12.hours))
        .uniq
  end

  def self.format_cart_items cart_items
    cart_item_lines = []
    cart_items.each do |cart_item|
      cart_item_line = []
      cart_item_line << cart_item.variant.showroom_picture
      cart_item_line << cart_item.name
      cart_item_line << "#{('%.2f' % cart_item.variant.retail_price).gsub('.',',')}"
      cart_item_line << cart_item.variant.product.description
      cart_item_lines << cart_item_line.join("|")
    end
    cart_item_lines.join("#")
  end

  def self.format_related_products related_products
    related_product_lines = []
    related_products.each do |product|
      related_product_line = []
      related_product_line << product.master_variant.showroom_picture
      related_product_line << "http://www.olook.com.br/produto/#{product.id}"
      related_product_line << product.name
      related_product_lines << related_product_line.join("|")
    end
    related_product_lines.join("#")
  end

end
