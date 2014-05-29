module SearchHelper

  HEEL_RANGE_LABELS = {
    '0-4' => 'Baixo (0cm - 4cm)',
    '5-9' => 'Médio (5cm - 9cm)',
    '10-15' => 'Alto (10cm - 15cm'
  }

  def heels(filters)
    filters.map{|f| f[0].chomp(" cm")}
  end

  def heel_label_for(heel_range)
    key = HEEL_RANGE_LABELS.keys.find { |k| /#{k}/ =~ heel_range }
    HEEL_RANGE_LABELS[key]
  end

  # TODO: Refactor this to improve readability
  def brand_link_to field, text, amount

    prefix = if field == :brand || @brand
      sanitized_brand = (@brand ? @brand : text).parameterize('_')
      "/marcas/#{sanitized_brand}?"
    else
      "/search/show?"
    end
    path = prefix + create_query_string(field => text)
    link_to "#{text} (#{amount})", path
  end

  def search_params(key, value, q)
    param_name = (key.downcase == "marcas") ? "brand" : "subcategory"
    {"#{param_name}" => "#{value}", "q" => q}.to_query
  end

  private
    def create_query_string hash
      params = {q: @q, color: @color, category: @category}
      params.merge! hash
      params.delete_if{|k,v| v.nil? || k.to_s == 'brand'}
      params.to_query
    end

end
