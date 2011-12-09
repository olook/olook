# -*- encoding : utf-8 -*-
class ProductPresenter < BasePresenter
  def collection_name
    I18n.t('date.month_names')[Date.today.month]
  end
  
  def render_member_showroom
    h.render :partial => 'product/member_showroom', :locals => {:product_presenter => self}
  end
  
  def render_main_profile_showroom
    h.render :partial => 'product/showroom_product', :collection => member.main_profile_showroom, :as => :product
  end
  
  def render_related_products
    h.render :partial => 'product/related_products', :locals => {:related_products => related_products}
  end

  def render_description
    h.render :partial => 'product/description', :locals => {:product_presenter => self}
  end

  def render_add_to_cart
    h.render :partial => 'product/add_to_cart', :locals => {:product_presenter => self}
  end

  def render_details
    h.render :partial => 'product/details', :locals => {:product_presenter => self}
  end

  def render_colors
    h.render :partial => 'product/colors', :locals => {:product => product}
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
    h.render :partial => 'product/sizes', :locals => {:variants => variants}
  end

  def related_products
    product.related_products.inject([]) do |result, related_product|
      if (related_product.category != product.category) &&
         (!related_product.sold_out?)
        result << related_product
      else
        result
      end
    end
  end
end
