# -*- encoding : utf-8 -*-
class ShowroomPresenter < BasePresenter
  presents :member

  def render_identification
    if member.has_facebook?
      h.render :partial => "showroom_facebook_connected"
    else
      h.render :partial => "showroom_facebook_connect"
    end
  end
  
  def collection_name
    I18n.t('date.month_names')[Date.today.month]
  end
  
  def display_products(asked_range, products = Array.new(20))
    range = parse_range(asked_range, products)

    output = ''
    (products[range] || []).each do |product|
      output << h.render(:partial => "shared/showroom_product_item", :locals => {:showroom_presenter => self, :product => product})
    end
    h.raw output
  end
  
  def product_picture(product)
    picture = product.showroom_picture
    if picture.nil?
      h.image_tag "fake/showroom-product.png"
    else
      h.image_tag picture
    end
  end

private
  def parse_range(asked_range, array)
    if asked_range.is_a? Range
      start_range = asked_range.first
      end_range = asked_range.last
    else
      start_range = asked_range
      end_range = start_range + 100000
    end
    end_range = (array.length-1) if end_range > (array.length-1)
    (start_range..end_range)
  end
end
