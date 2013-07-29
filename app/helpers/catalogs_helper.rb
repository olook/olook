# encoding: utf-8
module CatalogsHelper
  CLOTH_SIZES_TABLE = ["PP","P","M","G","GG","33","34","35","36","37","38","39","40","42","44","46","Único","Tamanho único"]
  HIGHLIGHT_BRANDS = {"olook" => 1, "olook concept" => 2}
  DOWNCASE_WORDS = Set.new( %w{ e de do da } )

  def filter_link_to(link, text, selected=false, amount=nil)
    span_class = text.downcase.parameterize
    search_param = params[:q].blank? ? "" : "?q=#{params[:q]}"
    text += " (#{amount})" if amount
    class_hash = selected ? {class: "selected"} : {}
    link+=search_param
    text = titleize_without_pronoum(text)
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
      text.capitalize!
    end
    text
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

  def filters_by filter, search, options={}
    filters = search.filters(options)
    facets = filters.grouped_products(filter)
    return [] if facets.nil?

    if filter == 'size'
      facets.keys.sort{|a,b| CLOTH_SIZES_TABLE.index(a.to_s).to_i <=> CLOTH_SIZES_TABLE.index(b.to_s).to_i}
    elsif filter == 'brand_facet'
      # Olook and Olook Concept must be shown at the top
      facets.keys.sort do |a,b|
        if !HIGHLIGHT_BRANDS[a.downcase].nil?
          -1
        elsif !HIGHLIGHT_BRANDS[b.downcase].nil?
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

end
