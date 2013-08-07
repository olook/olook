class AntibounceBox
  attr_accessor :search, :url_builder
  def initialize(params)
    formatted_params = format_params(SeoUrl.parse(params))
    @search = generate_search(formatted_params)
    @url_builder = SeoUrl.new(formatted_params, "category", @search)    
  end

  def self.need_antibounce_box?(search, brands, params)
    response = false
    search.products # Calling this method in order to retrieve pages and current page
    response = (search.pages == search.current_page && (["olook", "olook concept", "olook essential", "olook essentials"] & brands).empty?) if ["brands", "catalogs"].include?(params["controller"]) && params["action"] == "show"
    response &&= (["roupa", "moda praia", "lingerie", ""].include?(params["category"]) && search.expressions["brand"].any?) if params["controller"] == "brands" && params["action"] == "show"
    response
  end  

  private
    def generate_search(search_params)
      # add the parameters to meet marketing needs, that are:
      # - this search cannot include the brands inside the params
      # - half of the search products must be from olook
      SearchEngine.new(search_params).with_limit(Setting.antibounce_product_lines * 3)
    end

    def format_params params
      antibounce_params = params.dup 
      brand = antibounce_params["brand"]
      antibounce_params.delete("brand")
      antibounce_params["excluded_brand"] = brand
      antibounce_params["category"] = "roupa" if antibounce_params["category"].blank? || ["roupa", "moda praia", "lingerie", ""].include?("roupa")
      antibounce_params
    end
end