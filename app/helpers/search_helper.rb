module SearchHelper
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

  def cache_search_result_page &page
    cache(@search, expires_in: 20.minutes) do 
      yield page
    end
  end

  private
    def create_query_string hash
      params = {q: @q, color: @color, category: @category}
      params.merge! hash
      params.delete_if{|k,v| v.nil? || k.to_s == 'brand'}
      params.to_query
    end

end
