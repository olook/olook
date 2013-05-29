module SearchHelper

  def brand_link_to field, text, amount
    sanitized_brand = @brand.parameterize('_') if @brand 

    prefix = if sanitized_brand
      "/marcas/#{sanitized_brand}?" 
    else
      "/search/show?"
    end
    path = prefix + create_query_string(field => text)
    link_to "#{text} (#{amount})", path
  end

  private
    def create_query_string hash
      params = {q: @q, color: @color, category: @category}
      params.delete_if{|k,v| v.nil?}
      params.merge! hash
      params.to_query   
    end

end
