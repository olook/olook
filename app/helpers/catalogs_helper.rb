# encoding: utf-8
module CatalogsHelper
  CLOTH_SIZES_TABLE = ["PP","P","M","G","GG","EXG","33","34","35","36","37","38","39","40","42","44","46","48","50","52","54","56","58","Único","Tamanho único"]
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
    link_to('Limpar Filtro', link, class: 'clean')
  end

  def filter_link_to(link, text, selected=false, amount=nil,follow=true)
    text = text.to_s.gsub('Ç', 'ç')
    span_class = text.downcase.parameterize
    text += " (#{amount})" if amount
    class_hash = selected ? {class: "selected"} : {}
    class_hash[:title] = text
    class_hash[:alt] = text
    class_hash[:rel] = 'nofollow' unless follow == true
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
    check_existence_of_facets('subcategory', facets, category: category).keys
  end

  def filters_by filter, search, options={}
    filters = search.filters(options)
    facets = filters.grouped_products(filter)
    return [] if facets.nil?
    facets = check_existence_of_facets(filter, facets)

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

  def translate_site_filters(filter, values)
    values = Set.new(values.map { |v| v.parameterize })
    translate_from_yml(filter, values) do |s|
      if values.include?(s.parameterize)
        s
      end
    end
  end

  def check_existence_of_facets(filter, facets, opts={})
    _facets = facets.inject({}) { |h, f| h[f[0].parameterize] = f; h }
    subs = translate_from_yml(filter, _facets, opts) do |s|
      if f = _facets[s.parameterize]
        [s, f[1]]
      end
    end
    Hash[subs.sort]
  end

  def translate_from_yml(filter, inputs, opts={}, &block)
    subs = []
    if filter.to_s == 'subcategory'
      subs = SeoUrl.all_categories[opts[:category]]
      subs ||= SeoUrl.all_subcategories
    elsif filter.to_s == 'color'
      subs = SeoUrl.whitelisted_colors
    elsif ['brand_facet', 'brand'].include?(filter.to_s)
      subs = SeoUrl.all_brands
    end
    if subs.size > 0
      subs.map! do |s|
        block.call(s)
      end
      subs.compact!
    else
      subs = inputs
    end
    subs
  end

  def format_search_query_parameters
    arr = []
    arr << "por=#{ params[:por]}" if params[:por].present? 
    arr << "preco=#{params[:preco]}" if params[:preco].present?
    arr << "por_pagina=#{params[:por_pagina]}" if params[:por_pagina].present?
    arr.join('&')
  end

  def more_products_link_to(link, text, style_class="")
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
    size = (size.chomp.to_i.to_s != "0") ? size.chomp.to_i.to_s : size.chomp
    if size && /nico/i !~ size
      size = size.upcase
    end
    size
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
    FACEBOOK_TITLES[category.to_s.to_sym]
  end

  def facebook_description category
    FACEBOOK_DESCRIPTIONS[category.to_s.to_sym]
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
    filters_by("color", search, use_fields: [:category]).select do |k,v|
      SeoUrl.whitelisted_colors.include?(k.titleize) && should_color_appear?(search, k)
    end.map {|c, count| [c.parameterize, count] }
  end

  def show_hot_products?(leaderboard, qty)
    rank = @leaderboard.rank(qty * 3)
    unsorted_hot_products = SearchEngine.new(product_id: rank, limit: qty * 3).products.inject({}) do |hash, p|
      hash[p.id.to_i] = p
      hash
    end
    hot_products = rank.map { |product_id| unsorted_hot_products[product_id.to_i] }.compact.first(qty)
    if hot_products.size == qty
      hot_products
    else
      false
    end
  end

  def has_subcategory?
    !@search.expressions["subcategory"].blank?
  end 

  private

  def should_color_appear?(search, text) 
    (color_selected?(search, text) && color_filter_present?(search)) || !color_filter_present?(search)
  end

  def color_selected?(search, text)
    search.filter_selected?(:color, text.chomp)
  end

  def color_filter_present?(search)
    search.filter_value(:color).present?
  end

  def has_filters_selected? search
    return true if search.selected_filters_for("subcategory").size > 0 
    return true if search.selected_filters_for("color").size > 0 
    return true if search.selected_filters_for("heel").size > 0
    return true if search.selected_filters_for("care").size > 0
    return true if search.selected_filters_for("brand").size > 0
    return true if search.selected_filters_for("size").size > 0
    return true if search.selected_filters_for("price").size > 0
    return false
  end
end
