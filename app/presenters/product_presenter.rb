# -*- encoding : utf-8 -*-
class ProductPresenter < BasePresenter

  SIZES_TABLE = Catalog::Catalog::CLOTH_SIZES_TABLE


  def collection_name
   Collection.active.try(:name) || I18n.l(Date.today, :format => '%B')
  end

  def render_member_showroom
    h.render :partial => 'product/member_showroom', :locals => {:product_presenter => self}
  end

  def render_main_profile_showroom
    h.render :partial => "shared/product_item", :collection => member.main_profile_showroom, :as => :product
  end

  def render_look_products
    h.render :partial => 'product/look_products', :locals => {:look_products => look_products, :product_presenter => self} if look_products.size > 1 
  end

  def render_description(show_facebook_button = true)
    h.render :partial => 'product/description', :locals => {:product_presenter => self, :show_facebook_button => show_facebook_button}
  end

  def display_main_picture
    image_url = product.pictures.first.image_url(:main).to_s if product.pictures.first
    "http://pinterest.com/pin/create/button/?url=http://#{h.request.host_with_port}/produto/#{product.id}&media=#{image_url}&description=#{h.share_description(product)}"
  end
  
  def render_quantity
    h.render :partial => 'product/quantity_product', :locals => {:product_presenter => self, :product => product}
  end  
  
  def render_add_to_cart
    return '' if only_view?

    if gift?
      h.render :partial => 'product/add_to_suggestions', :locals => {:product_presenter => self, :product => product}
    else
      h.render :partial => 'product/add_to_cart', :locals => {:product_presenter => self, :product => product}
    end
  end

  def render_details
    h.render :partial => 'product/details', :locals => {:product_presenter => self}    
  end

  def render_colors
    return '' if only_view?
    h.render :partial => 'product/colors', :locals => {:product => product, :gift => gift?, :shoe_size => shoe_size}
  end

  def render_facebook_comments
    h.render :partial => 'product/facebook_comments', :locals => {:product => product, :facebook_app_id => facebook_app_id}
  end

  def render_form_by_category
    case product.category
      when Category::SHOE then h.render :partial => 'product/form_for_shoe', :locals => {:product_presenter => self}
      when Category::BAG then h.render :partial => 'product/form_for_bag', :locals => {:product_presenter => self}
      when Category::ACCESSORY then h.render :partial => 'product/form_for_accessory', :locals => {:product_presenter => self}
      when Category::CLOTH then h.render :partial => 'product/form_for_cloth', :locals => {:product_presenter => self}
      when Category::LINGERIE then h.render :partial => 'product/form_for_cloth', :locals => {:product_presenter => self}
      when Category::BEACHWEAR then h.render :partial => 'product/form_for_cloth', :locals => {:product_presenter => self}
    end
  end

  def render_single_size
    variant = product.variants.sorted_by_description.first
    h.render :partial => 'product/single_size', :locals => {:variant => variant}
  end

  def render_multiple_sizes
    variants = product.variants.sorted_by_description
    h.render :partial => 'product/sizes', :locals => {:variants => variants, :shoe_size => shoe_size, :show_cloth_size_table => false}
  end

  def render_accessory_sizes
    if variants_sorted_by_size.size == 1
      single_size = variants_sorted_by_size.first.description
    end
    h.render :partial => 'product/sizes', :locals => {:variants => variants_sorted_by_size, :shoe_size => single_size, :show_cloth_size_table => false}
  end

  def render_cloth_sizes
    h.render :partial => 'product/sizes', :locals => {:variants => variants_sorted_by_size, :shoe_size => nil, :show_cloth_size_table => true}
  end

  def render_pics
    h.render :partial => "product_pics", :locals => {:product_presenter => self}
  end

  def show_quantity_left?
    member && quantity_left > 0 && quantity_left < 4
  end

  def quantity_left
    product.quantity(member.shoes_size)
  end

  def quantity_left_text
    more_than_one_left? ? "Restam apenas " : "Resta apenas "
  end

  def unities_left_text
    more_than_one_left? ? "unidades" : "unidade"
  end

  def more_than_one_left?
    quantity_left > 1
  end

  def look_products
    product_list = product.related_products.inject([]) do |result, related_product|
      if (related_product.name != product.name && related_product.category) &&  (!related_product.sold_out?)
        result << related_product
      else
        result
      end
    end
    product_list.any? ? ([product] + product_list) : product_list
  end

  def render_price_for product_discount_service
    product_discount_service.calculate
    return price_markdown(product_discount_service) if product_discount_service.discount > 0
    return price_markup(product_discount_service.final_price, "price")
  end

  def is_promotion?
    (!member || (member && member.first_time_buyer?)) && (product.retail_price > (product.price * 0.8)) || product.promotion?
  end

  def user_expiration_month(user)
    "%02d" % ::DiscountExpirationCheckService.discount_expiration_date_for(user).month.to_s
  end

  def user_expiration_day(user)
    "%02d" % ::DiscountExpirationCheckService.discount_expiration_date_for(user).day.to_s
  end

  private

    def price_markdown discount_service
      price_markup(discount_service.base_price, "price_retail left2", "de: ") +
      price_markup(discount_service.final_price, "price left2", "por: ")
    end

    def price_markup price, css_class, prefix=nil
      content = h.number_to_currency(price)
      content = prefix + content if prefix
      h.content_tag(:p, content ,:class => css_class)
    end

    def variants_sorted_by_size
      product.variants.sort{|first, second| SIZES_TABLE[first.description].to_i <=> SIZES_TABLE[second.description].to_i }
    end
end
