# -*- encoding : utf-8 -*-
class ProductPresenter < BasePresenter
  presents :product
  
  def collection_name
    I18n.t('date.month_names')[Date.today.month]
  end
  
  def member_showroom
    h.render :partial => 'product/member_showroom', :locals => {:product_presenter => self}
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
    h.render :partial => 'product/colors', :locals => {:product_presenter => self}
  end

  def render_sizes
    h.render :partial => 'product/sizes', :locals => {:product_presenter => self}
  end
end
