# -*- encoding: utf-8 -*-
module ProductsHelper
  HEEL_MODELS = ["anabela","ankle boot","boneca","bota","creeper","oxford","peep toe","sandália","scarpin","sneaker"]
  SORT_WORDS = ["Confira!","Clique e confira!", "Veja mais!","Conheça!"]
  MALE_CATEGORY = [1,3]

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
        classes << "selected" if variant.description.to_s == shoe_size.to_s || variant_only_contains_unique_size(variant)
      end
    end
    classes.join(" ")
  end

  def share_description(product,has_link=true)
    article = MALE_CATEGORY.include?(product.category) ? "o" : "a"
    message = "Vi #{article} #{product.category_humanize.downcase} #{product.name} no site da Olook e amei! <3"
    message.concat(" #{product_seo_url(product.seo_path)}") if has_link
    message
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
    elsif name == 'detalhes' && HEEL_MODELS.include?(product.model_name.downcase)
      'Salto'
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

  def product_sum_discount(look_products, discount, is_percentage)
    if is_percentage
      look_products.inject(0.0){|s,p| s + ((p.retail_price < calculate_look_product_discount_for(p, discount)) ? p.retail_price : calculate_look_product_discount_for(p, discount)) }
    else
      look_products.inject(0.0){|s,p| s + (p.promotion? ? p.retail_price : p.price)} - discount
    end
  end

  def calculate_look_product_discount_for(product, discount)
    (product.price * (1 - (discount/100.0)))
  end

  def modify_meta_description description, color
    _description = description || ""
    _description = "#{_description} Cor #{color}" unless color == "Não informado" || color.blank?
    "#{_description}. #{sort_words}"
  end

  def sort_words
    SORT_WORDS.sample
  end

  def pictures_for product      
    limit = product.youtube_token.blank? ? 7 : 6
    product.pictures.order(:display_on).first(limit)
  end

  private

  def variant_only_contains_unique_size variant
    variant.description.to_s.parameterize.include?("unico")
  end

end
