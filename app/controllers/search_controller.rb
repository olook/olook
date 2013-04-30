class SearchController < ApplicationController
  respond_to :html

  def index

  end

  def show
    #url = URI.parse("http://search-olook-products-m7cmewyo4k3ih7na2nzixh5jae.us-east-1.cloudsearch.amazonaws.com/2011-02-01/search?q=#{CGI.escape params[:q]}&return-fields=categoria,name,description,image,price,text_relevance")
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

      OpenStruct.new(
        id: hit["id"].to_i, 
        formatted_name: data["name"][0], 
        model_name: data["categoria"][0],
        category: data["category"][0],
        catalog_image: data["image"][0], 
        backside_picture: data["backside_image"][0],
        price: BigDecimal.new(data["price"][0]), 
        promotion?: false
      )
    end

    @show_filters = wanted_category.nil? && wanted_brand.nil?
    @products.compact!
    @q=params[:q]
    #####END

  end

  def product_suggestions
    render json: ProductSearch.terms_for(params[:term].downcase)
  end

end
