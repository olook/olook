class SearchController < ApplicationController
  respond_to :html
  layout "lite_application"

  def index

  end

  def show
    @q = params[:q]
    @brand = params[:brand].humanize if params[:brand]
    @color = params[:color]
    @category = params[:category].parameterize if params[:category]

    url_builder = SearchUrlBuilder.new 

    # Gambiarra temporária
    if @brand == "All"
      @q, @brand = "a*", nil
      @dont_show_message = true
    end

    url = url_builder
      .for_term(@q)
      .with_category(@category)
      .with_brand(@brand)
      .with_color(@color)
      .grouping_by
      .build_url

    # .build_url_with({category: params[:category], brand: params[:brand], rank: "cor_e_marca"})

    response = Net::HTTP.get_response(url)
    @hits = JSON.parse(response.body)["hits"]
    @facets = JSON.parse(response.body)["facets"]

    @brands = group "brand_facet"
    @model_names = group "categoria"
    @colors = group "cor_filtro"

    @products = @hits["hit"].map do |hit|
      SearchedProduct.new(hit["id"].to_i, hit["data"])
    end

    @show_filters = true
    @products.compact!

    @stylist = Product.fetch_products :selection
  end

  def product_suggestions
    render json: ProductSearch.terms_for(params[:term].downcase)
  end

  private
    def group facet_name
      facet_list = {}
      return {} if @facets[facet_name].nil?

      @facets[facet_name]["constraints"].map do |facet|
        facet_name = facet["value"].humanize
        facet_count = facet["count"]
        facet_list[facet_name] = facet_count
      end
      facet_list
    end

  

end
