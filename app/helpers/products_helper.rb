 # -*- coding: utf-8 -*-
module ProductsHelper
  def variant_classes(variant, shoe_size = nil)
    classes = []
    if !variant.available_for_quantity?
      classes << "unavailable"
    else
      if shoe_size.nil? || shoe_size <= 0
        if current_user && current_user.shoes_size &&
          variant.description == current_user.shoes_size.to_s
            classes << "selected"
        end
      else
        classes << "selected" if variant.description.to_s == shoe_size.to_s
      end
    end
    classes.join(" ")
  end

  def twit_description(product)
    if product.category == 1 #shoes
      "Vi o sapato #{product.name} no site da olook e amei! <3 http://www.olook.com.br/produto/#{product.id}"
    elsif product.category == 2 #purse
      "Vi a bolsa #{product.name} no site da olook e amei! <3 http://www.olook.com.br/produto/#{product.id}"
    else #accessory
      "Vi o acessório #{product.name} no site da olook e amei! <3 http://www.olook.com.br/produto/#{product.id}"
    end
  end
end
