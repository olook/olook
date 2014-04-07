# encoding: utf-8
module CatalogsHelper
  CLOTH_SIZES_TABLE = ["PP","P","M","G","GG","EXG","33","34","35","36","37","38","39","40","42","44","46","Único","Tamanho único"]
  CLOTH_CLASSES_HASH = {
    "Único" => "unico",
    "Unico" => "unico",
    "Clucth" => "unico",
    "Grande" => "grande",
    "Bolsa Grande" => "bolsa_grande",
    "Bolsa Média" => "bolsa_grande",
    "Tamanho único" => "tamanho_unico",
    "Regulável" => "tamanho_regulavel"
  }
  UPCASE_BRANDS = ["TVZ"]
  HIGHLIGHT_BRANDS = {"olook" => 1, "olook concept" => 2, "olook essential" => 3, "olook curves" => 4}
  DOWNCASE_WORDS = Set.new( %w{ e de do da a o } )

  FACEBOOK_TITLES = {
    sapato: "Olook | Sapatos Femininos Online",
    bolsa: "Olook | Compre bolsas femininas online",
    acessorio: "Olook | Acessórios femininos",
    roupa: "Olook | Roupas Femininas Online",
    curves: "Olook Curves | Roupas femininas Plus Size"    
  }

  FACEBOOK_DESCRIPTIONS = {
    sapato: "Comprar sapatos online é mais fácil e mais seguro quando você compra na Olook. Encontre modelos de sapatilhas, botas e saltos diversos para todas as ocasiões.",
    bolsa: "Compre bolsas femininas online com facilidade e segurança. Na Olook você encontra bolsas e clutches das melhores marcas.",
    acessorio: "Na Olook você encontra todos os tipos de acessórios para pontuar seus looks. Compre maxi colares, brincos e carteiras com segurança e praticidade!",
    roupa: "Na Olook você compra roupas das melhores marcas online com segurança e praticidade. Achados da Colcci, Lez a Lez, Cantão e  M.Officer para todas as ocasiões.",
    curves: "Encontre roupas femininas com tamanhos grandes ou especiais na Olook. Comprar roupas plus size online ficou mais fácil e seguro!"    
  }

  PRICE_RANGES = {
    "0-70" => "Até R$ 69,90",
    "70-130" => "R$ 70 a R$ 129,90",
    "130-200" => "R$ 130,00 a R$ 199,90",
    "200-1000" => "Acima de R$ 200"
  }

  def clean_filter_link_to(link)
    link += params[:q].blank? ? "" : "?q=#{params[:q]}"

    link_to('Limpar Filtro', link, class: 'clean')
  end

  def filter_link_to(link, text, selected=false, amount=nil)
    span_class = text.downcase.parameterize
    search_param = params[:q].blank? ? "" : "?q=#{params[:q]}"
    text += " (#{amount})" if amount
    class_hash = selected ? {class: "selected"} : {}
    class_hash[:title] = text
    class_hash[:alt] = text
    link+=search_param
    text = CLOTH_SIZES_TABLE.include?(text) ? text : titleize_without_pronoum(text)
    
    link_to(link, class_hash) do
      content_tag(:span, text, class:"txt-#{span_class}")
    end
  end

  def titleize_without_pronoum(text)
    textarr = text.split(' ')
    if textarr.size > 1
      f = textarr.shift.capitalize
      textarr.map! { |w| DOWNCASE_WORDS.include?(w.downcase) ? w.downcase : w.capitalize  }
      text = [f, textarr].flatten.join(' ')
    else
      if UPCASE_BRANDS.include?(text.upcase)
        text.upcase!
      else
        text.capitalize!
      end
    end
    text
  end
  
  def product_permalink(product)
    "/produto/" + product.formatted_name.parameterize + "-" + product.id.to_s 
  end  
  
  def current_section_link_to(link, selected=false)
    search_param = params[:q].blank? ? "" : "?q=#{params[:q]}"
    link+=search_param
    link_to("x", link)
  end

  def formated_heel heel
    case
    when heel == '0..4'
      "Baixo (0cm - 4cm)"
    when heel == '5..9'
      "Médio (5cm - 9cm)"
    else
      "Alto (10cm - 18cm)"
    end
  end


  def subcategory_filters_by category, search, options={}
    filters = search.filters(options)
    facets = filters.grouped_products('subcategory')
    return [] if facets.nil?
    subs = Set.new(SeoUrl.all_categories[category].map {|s| s.parameterize })
    facets.select! { |f| subs.include?(f.parameterize) }
    facets.sort
  end

  def filters_by filter, search, options={}
    filters = search.filters(options)
    facets = filters.grouped_products(filter)
    return [] if facets.nil?

    if filter == 'size'
      facets.keys.map{|k| [((k.to_i != 0) ? k.to_i.to_s : k), k]}.sort{|a,b| CLOTH_SIZES_TABLE.index(a[0].to_s).to_i <=> CLOTH_SIZES_TABLE.index(b[0].to_s).to_i}.map{|v| v[1]}
    elsif filter == 'brand_facet'

      # Olook and Olook Concept must be shown at the top
      facets.keys.sort do |a,b|
        if HIGHLIGHT_BRANDS.keys.include?(a.downcase) && HIGHLIGHT_BRANDS.keys.include?(b.downcase)
          HIGHLIGHT_BRANDS[a.downcase] <=> HIGHLIGHT_BRANDS[b.downcase]
        elsif HIGHLIGHT_BRANDS.keys.include? a.downcase
          -1
        elsif HIGHLIGHT_BRANDS.keys.include? b.downcase
          1
        else
          a <=> b
        end
      end
    else
      facets.sort
    end
  end

  def format_search_query_parameters
    arr = []
    arr << "por=#{ params[:por]}" if params[:por].present? 
    arr << "preco=#{params[:preco]}" if params[:preco].present?
    arr << "por_pagina=#{params[:por_pagina]}" if params[:por_pagina].present?
    arr.join('&')
  end

  def more_products_link_to(link, text, style_class="")
    span_class = text.downcase.parameterize
    text = titleize_without_pronoum(text)
    link_to(link) do
      content_tag(:span, text, class: "#{style_class}", onclick: track_event("AntibounceBox", "SeeMoreProducts"))
    end
  end  

  def order_variants_by_size(variants_array)
    variants_array.sort{|a,b| CLOTH_SIZES_TABLE.index(a.description.to_s).to_i <=> CLOTH_SIZES_TABLE.index(b.description.to_s).to_i}
  end

  def category_style_class text
    CLOTH_CLASSES_HASH.keys.include?(text) ? CLOTH_CLASSES_HASH[text] : ''
  end

  def format_size size
    (size.chomp.to_i.to_s != "0") ? size.chomp.to_i.to_s : size.chomp
  end

  def should_size_appear_in_olooklet_menu?(text)
    (CLOTH_SIZES_TABLE - ["Tamanho único"]).include?(format_size(text))
  end

  def size_list(categories, search, category_abbr, fields = [:category])
    old_categories = search.current_filters[:category]
    search.category = categories
    response = filters_by('size', search, use_fields: fields).reject do |text,amount|
      (text.to_i != 0 && text[text.size-1] != category_abbr.downcase) || !should_size_appear_in_olooklet_menu?(text)
    end
    search.category = old_categories
    response
  end

  def facebook_title category
    FACEBOOK_TITLES[category.to_sym]
  end

  def facebook_description category
    FACEBOOK_DESCRIPTIONS[category.to_sym]
  end

  def label_for_price_range price_range
    PRICE_RANGES[price_range]
  end  

  def size_select_options(sizes, url_builder)
    response = {}

    response["Selecione um Tamanho"] = size_select_link_for("", url_builder) 
    sizes.each{|s| response[format_size(s)] = size_select_link_for(s.downcase.parameterize, url_builder)}

    response
  end

  def size_select_link_for(size, url_builder)
    link = size.blank? ? url_builder.remove_filter_of(:size) : url_builder.replace_filter(:size, size.downcase.parameterize)
    link[0] = ''
    "#{root_url}#{link}"
  end

  def selected_size(search, url_builder)
    search.filter_value(:size) ? search.filter_value(:size).first : ""
  end

  def selected_size_link(search, url_builder)
    size_select_link_for(selected_size(search, url_builder), url_builder)
  end

  def selected_size_label(search, url_builder)
    size = selected_size(search, url_builder)
    (size.blank?) ? "Selecione um Tamanho" : format_size(size)
  end

  def whitelisted_color_filters(search)
    filters_by("color", search, use_fields: [:category]).select{|k,v| SeoUrl.whitelisted_colors.include?(k)}
  end
end
