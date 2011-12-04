# -*- encoding : utf-8 -*-
class ShowroomPresenter < BasePresenter
  presents :member
  
  MORNING   = (0..11)
  AFTERNOON = (12..18)
  EVENING   = (19..23)

  def render_identification
    if member.has_facebook?
      h.render :partial => "showroom_facebook_connected", :locals => {:showroom_presenter => self}
    else
      h.render :partial => "showroom_facebook_connect", :locals => {:showroom_presenter => self}
    end
  end
  
  def collection_name
    I18n.t('date.month_names')[Date.today.month]
  end
  
  def display_products(asked_range, category)
    products = member.all_profiles_showroom(category)
    range = parse_range(asked_range, products)

    output = ''
    (products[range] || []).each do |product|
      output << h.render(:partial => "shared/showroom_product_item", :locals => {:showroom_presenter => self, :product => product})
    end
    h.raw output
  end
  
  def display_shoes(asked_range)
    display_products(asked_range, Category::SHOE)
  end

  def display_bags(asked_range)
    display_products(asked_range, Category::BAG)
  end

  def display_accessories(asked_range)
    display_products(asked_range, Category::ACCESSORY)
  end

  def product_picture(product)
    picture = product.showroom_picture
    if picture.nil?
      h.image_tag "fake/showroom-product.png"
    else
      h.image_tag picture
    end
  end

  def welcome_message(time = Time.now.hour)
    case
      when MORNING.cover?(time)   then "Bom dia, #{member.first_name}!"
      when AFTERNOON.cover?(time) then "Boa tarde, #{member.first_name}!"
      when EVENING.cover?(time)   then "Boa noite, #{member.first_name}!"
    end
  end
  
  def facebook_avatar
    # Visit https://developers.facebook.com/docs/reference/api/ for more info
    h.image_tag "https://graph.facebook.com/#{member.uid}/picture?type=large", :class => 'avatar'
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
