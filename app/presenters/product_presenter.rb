# -*- encoding : utf-8 -*-
class ProductPresenter < BasePresenter
  def collection_name
   Collection.active.try(:name) || I18n.l(Date.today, :format => '%B')
  end

  def render_member_showroom
    h.render :partial => 'product/member_showroom', :locals => {:product_presenter => self} if member.is_old?
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
    h.render :partial => 'product/add_to_cart', :locals => {:product_presenter => self, :product => product}
  end

  def render_offline_add_to_cart
    h.render :partial => 'product/offline_add_to_cart', :locals => {:product_presenter => self, :product => product}
  end

  def render_details
    h.render :partial => 'product/details', :locals => {:product_presenter => self}
  end

  def render_colors
    h.render :partial => 'product/colors', :locals => {:product => product}
  end

  def render_facebook_comments
    h.render :partial => 'product/facebook_comments', :locals => {:product => product, :facebook_app_id => facebook_app_id}
  end
  
  def render_add_to_suggestions
    h.render :partial => 'product/add_to_suggestions', :locals => {:product_presenter => self, :product => product}
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
    more_than_one_left? ? "Restam apenas" : "Resta apenas"
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
end
