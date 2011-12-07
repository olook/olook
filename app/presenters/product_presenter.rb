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
    h.render :partial => 'product/related_products', :locals => {:product_presenter => self}
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

  def render_sizes
    selected_variants = product.variants.sorted_by_description
    if selected_variants.length == 1
      h.render :partial => 'product/single_size', :locals => {:variant => selected_variants.first}
    else
      h.render :partial => 'product/sizes', :locals => {:variants => selected_variants}
    end
  end
  
  def related_products
    product.related_products.inject([]) do |result, related_product|
      related_product.category != product.category ? result << related_product : result
    end
  end
end
