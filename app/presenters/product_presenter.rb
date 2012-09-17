# -*- encoding : utf-8 -*-
class ProductPresenter < BasePresenter
  def collection_name
   Collection.active.try(:name) || I18n.l(Date.today, :format => '%B')
  end

  def render_member_showroom
    h.render :partial => 'product/member_showroom', :locals => {:product_presenter => self}
  end

  def render_main_profile_showroom
    h.render :partial => "shared/showroom_product_item", :collection => member.main_profile_showroom, :as => :product
  end

  def render_related_products
    h.render :partial => 'product/related_products', :locals => {:related_products => related_products}
  end

  def render_description
    h.render :partial => 'product/description', :locals => {:product_presenter => self}
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
    end
  end

  def render_single_size
    variant = product.variants.sorted_by_description.first
    h.render :partial => 'product/single_size', :locals => {:variant => variant}
  end

  def render_multiple_sizes
    variants = product.variants.sorted_by_description
    h.render :partial => 'product/sizes', :locals => {:variants => variants, :shoe_size => shoe_size}
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

  def related_products
    product.related_products.inject([]) do |result, related_product|
      if (related_product.name != product.name && related_product.category) &&  (!related_product.sold_out?)
        result << related_product
      else
        result
      end
    end
  end

  def render_price
    if (!member || (member && member.first_time_buyer?)) && (product.retail_price > (product.price * 0.8))
      price_markdown(:promotion_price) + promotion_explanation
    elsif product.promotion? #discount
      price_markdown(:retail_price)
    else
      price_markup(product.price, "price")
    end
  end

  def is_promotion?
    (!member || (member && member.first_time_buyer?)) && (product.retail_price > (product.price * 0.8)) || product.promotion?
  end

  private

  def price_markdown discount_method
    price_markup(product.price, "price_retail left", "de: ") +
    price_markup(product.send(discount_method), "price left", "por: ")
  end

  def price_markup price, css_class, prefix=nil
    content = h.number_to_currency(price)
    content = prefix + content if prefix
    h.content_tag(:p, content ,:class => css_class)
  end

  def promotion_explanation
    h.content_tag(:p, "em sua primeira compra", :class => "promotion_explanation")
  end
end
