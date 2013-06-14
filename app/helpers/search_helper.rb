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

  def filter_link_to(path, field, text, amount=nil)
    filter_link = create_query_string(field => text.parameterize)
    text += " (#{amount})" if amount
    link_to text, path + "?#{filter_link}"
  end

  private
    def create_query_string hash
      params = {q: @q, color: @color, category: @category}
      params.merge! hash
      params.delete_if{|k,v| v.nil? || k.to_s == 'brand'}
      params.to_query
    end

end
