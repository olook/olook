# -*- encoding: utf-8 -*-
module ProductsHelper

  def variant_classes(variant, shoe_size = nil)
    classes = []
    if !variant.available_for_quantity?
      classes << "unavailable"
    else
      if shoe_size.nil? #|| shoe_size <= 0
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

  def share_description(product)
    if product.category == 1 #shoes
      "Vi o sapato #{product.name} no site da olook e amei! <3 www.olook.com.br/produto/#{product.id}"
    elsif product.category == 2 #purse
      "Vi a bolsa #{product.name} no site da olook e amei! <3 www.olook.com.br/produto/#{product.id}"
    else #accessory
      "Vi o acessório #{product.name} no site da olook e amei! <3 www.olook.com.br/produto/#{product.id}"
    end
  end

  def print_detail_name_for product, detail

    name = detail.translation_token.downcase
    category = product.category

    if name == 'categoria'
      'Modelo'
    elsif name == 'material externo' && category == Category::CLOTH
      'Composição'
    elsif name == 'salto' && category == Category::CLOTH
      'Tamanhos & Medidas'
    elsif name == 'salto' && (category == Category::BAG || category == Category::ACCESSORY)
      'Tamanho'
    elsif name == 'metal' && category == Category::ACCESSORY
      'Material'
    elsif name == 'detalhe' && product.is_a_shoe_accessory?
      'Instruções'
    else
      detail.translation_token
    end

  end

  def print_detail_value detail
    html_sizes = ""
    sizes = detail.description.split(";")
    sizes.each do |size|
      html_sizes << "#{size.chomp}<br>"
    end
    rallow = %w{ p b i br }.map { |w| "#{w}\/?[ >]" }.join('|')
    html_sizes.gsub!(/<\/?(?!(?:#{rallow}))[^>\/]*\/?>/i, '')
    html_sizes.html_safe
  end

  def sku_for product
    product.master_variant.sku
  end

  def look_products_sum look_products
    look_products.sum{|p| p.promotion? ? p.retail_price : p.price}
  end

  def product_sum_discount(sum, discount, is_percentage)
    is_percentage ? sum * (1 - (discount/100.0)) : sum - discount  
  end

  def display_discount_text(discount, is_percentage)
    is_percentage ? "#{discount}%" : number_to_currency(discount)  
  end

end
