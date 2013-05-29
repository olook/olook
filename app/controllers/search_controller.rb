class SearchController < ApplicationController
  respond_to :html
  layout "lite_application"

  def index

  end

  def show

    url_builder = SearchUrlBuilder.new params[:q]
    url = url_builder.build_url_with({category: params[:category], brand: params[:brand], rank: "cor_e_marca"})

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

end
