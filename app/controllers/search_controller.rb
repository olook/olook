class SearchController < ApplicationController
  respond_to :html

  def index

  end

  def show
    url = URI.parse("http://busca.olook.com.br/2011-02-01/search?q=#{CGI.escape params[:q]}&return-fields=categoria,name,brand,description,image,price,backside_image,category,text_relevance")
    response = Net::HTTP.get_response(url)

    wanted_category = params[:category]
    wanted_brand = params[:brand]

    @hits = JSON.parse(response.body)["hits"]  

    #### PROTOTYPE
    @categories = {}
    @brands = {}

    @products = @hits["hit"].map do |hit| 
      data = hit["data"]
      brand = data["brand"][0].downcase.strip
      category = data["categoria"][0].downcase.strip

      if wanted_category && wanted_category.downcase != category
        next
      end

      if wanted_brand && wanted_brand.downcase != brand
        next
      end

      @brands[brand] = @brands[brand].to_i + 1
      @categories[category] = @categories[category].to_i + 1

      SearchedProduct.new(hit["id"].to_i, data)
    end


    @show_filters = wanted_category.nil? && wanted_brand.nil?
    @products.compact!
    @q=params[:q]
    #####END

  end

  def product_suggestions
    render json: ProductSearch.terms_for(params[:term].downcase)
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
