class SearchController < ApplicationController
  respond_to :html
  layout "lite_application"
  
  def index

  end

  def show

    url_builder = SearchUrlBuilder.new params[:q]
    url = url_builder.build_url_with({category: params[:category], brand: params[:brand]})

    response = Net::HTTP.get_response(url)
    @hits = JSON.parse(response.body)["hits"]  


    @model_names = {}
    @brands = {}

    @products = @hits["hit"].map do |hit| 
      data = hit["data"]
      brand = data["brand"][0].nil? ? "" : data["brand"][0].strip.capitalize
      model = data["categoria"][0].nil? ? "" : data["categoria"][0].strip.capitalize
      category = data["category"][0].nil? ? "" : data["category"][0].strip.capitalize

      @brands[brand] = @brands[brand].to_i + 1
      @model_names[category] ||= {}
      @model_names[category][model] = @model_names[category][model].to_i + 1

      SearchedProduct.new(hit["id"].to_i, data)
    end

    # @show_filters = wanted_category.nil? && wanted_brand.nil?
    @show_filters = true
    @products.compact!
    @q=params[:q]
    #####END
    
    ### to render home partials ###
    @stylist = Product.fetch_products :selection
  end

  def product_suggestions
    render json: ProductSearch.terms_for(params[:term].downcase)
  end

  class SearchUrlBuilder
    SEARCH_CONFIG = YAML.load_file("#{Rails.root}/config/cloud_search.yml")[Rails.env]
    BASE_URL = SEARCH_CONFIG["search_domain"]

    def initialize term
      @term = term
    end

    def build_url_with attributes={}
      query = "q=#{CGI.escape @term}"
      query += "&bq=categoria%3A'#{CGI.escape attributes[:category]}'" if attributes[:category]
      query += "&bq=brand%3A'#{CGI.escape attributes[:brand]}'" if attributes[:brand]
      query += "&size=100"
      URI.parse("http://#{BASE_URL}/2011-02-01/search?#{query}&return-fields=categoria,name,brand,description,image,price,backside_image,category,text_relevance")
    end

  end

  class SearchedProduct

    attr_accessor :id, :formatted_name, :model_name, :category, :catalog_image, :backside_picture, :price, :brand
    attr_writer :promotion

    def initialize id, data
      self.id = id
      self.formatted_name = data["name"][0] 
      self.model_name = data["categoria"][0]
      self.category = data["category"][0]
      self.catalog_image = data["image"][0]
      self.backside_picture = data["backside_image"][0]
      self.brand = data["brand"][0]
      self.price = BigDecimal.new(data["price"][0])
      self.promotion = false
    end

    def promotion?
      @promotion
    end

  end

end
