# encoding: utf-8
module CatalogsHelper
  CLOTH_SIZES_TABLE = {"PP" => 1, "P" =>2, "M" => 3, "G" => 4, "GG" => 5,
                 "34" => 6, "36" => 7, "38" => 8, "40" => 9, "42" => 10, "44" => 11, "46" => 12,
                 "Único" => 13}

  HIGHLIGHT_BRANDS = {"olook" => 1, "olook concept" => 2}

  def filter_link_to(link, text, selected=false, amount=nil)
    span_class = text.downcase
    search_param = params[:q].blank? ? "" : "?q=#{params[:q]}"
    text += " (#{amount})" if amount
    class_hash = selected ? {class: "selected"} : {}
    link+=search_param
    link_to(link, class_hash) do
      content_tag(:span, text, class:"txt-#{span_class}")
    end
  end

  def current_section_link_to(link, selected=false)
    search_param = params[:q].blank? ? "" : "?q=#{params[:q]}"
    link+=search_param
    link_to("( x )", link)
  end

  def filters_by filter
    facets = @filters.grouped_products(filter)

    if filter == 'size'
      facets.keys.sort{|a,b| CLOTH_SIZES_TABLE[a.to_s].to_i <=> CLOTH_SIZES_TABLE[b.to_s].to_i}
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

end
