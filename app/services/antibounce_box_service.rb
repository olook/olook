class AntibounceBoxService
  def self.generate_search(params)
    # add the parameters to meet marketing needs, that are:
    # - this search cannot include the brands inside the params
    # - half of this search products must be from olook
    search_params = SeoUrl.parse(format_params(params))
    SearchEngine.new(search_params).with_limit(Setting.antibounce_product_lines * 3)
  end

  def self.need_antibounce_box?(search, brands)
    search.products # Calling this method in order to retrieve pages and current page
    search.pages == search.current_page && (["olook", "olook concept", "olook essential", "olook essentials"] & brands).empty?
  end

  def self.format_params params
    antibounce_params = params.dup 
    brand = antibounce_params["brand"]
    antibounce_params.delete("brand")
    antibounce_params["excluded_brand"] = brand
    antibounce_params["category"] = "roupa" if antibounce_params["category"].blank?
    antibounce_params
  end

end