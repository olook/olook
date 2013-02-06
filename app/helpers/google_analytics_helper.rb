# -*- encoding : utf-8 -*-
module GoogleAnalyticsHelper
  def google_ids product=nil, cart=nil
    google_ids = product.id if product
    google_ids = cart.items.map(&:variant_id) if cart
    google_ids
  end


  def google_name product=nil, cart=nil
    google_name = product.id if product
    google_name = cart.items.map(&:name).to_s.gsub(/"/, "'") if cart
    google_name
  end

  def google_cat product=nil, cart=nil
    google_cat = product.category_humanize if product
    google_cat = cart.items.map{|p| p.product.category_humanize.to_s}.to_s.gsub(/"/, "'") if cart
    google_cat
  end

  def google_value product=nil, cart=nil
    google_value = product.id if product
    google_value = cart.items.map{|p| p.retail_price.to_s}.to_s.gsub(/"/, "'") if cart
    google_value
  end

end
