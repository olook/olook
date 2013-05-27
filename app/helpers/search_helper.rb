module SearchHelper

  def search_link_to q, brand, model, amount
    if brand && !brand.empty?
      path = "#{brand}/?"
    else
      path = "show?"
    end

    if q && !q.nil?
      path += "q=#{q}&"
    end

    if model && !model.nil?
      path += "category=#{model}"
    end

    link_to "#{model} (#{amount})", path
  end

  def brand_link_to q, brand, amount
    sanitized_brand = brand.parameterize('_')
    link_to "#{brand} (#{amount})", "/marcas/#{sanitized_brand}?q=#{@q}"
  end

end
