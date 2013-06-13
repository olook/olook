# -*- encoding : utf-8 -*-
class CatalogsController < ApplicationController
  layout "lite_application"
  respond_to :html, :js
  before_filter :load_catalog_products

  def show
    @pixel_information = params[:category_id]
    if CollectionTheme.active.first.try(:catalog).try(:products).nil?
      flash[:notice] = "A coleção não possui produtos disponíveis"
      redirect_to member_showroom_path
    else
      respond_with @catalog_products
    end
  end

  def load_catalog_products

    @category = params[:category]
    @category = "roupa"
    @category_id = Category.with_name @category
    @colors = Detail.colors(@category_id)

    url = SearchUrlBuilder.new
      .with_category(@category)
      .grouping_by
      .build_url

    # .build_url_with({category: params[:category], brand: params[:brand], rank: "cor_e_marca"})
    @result = fetch_products url
    @catalog_products = @result.products
    @products_id = @catalog_products.first(3).map{|item| item.id }.compact
    @collection_theme = CollectionTheme.find 1
  end

  private

    def fetch_products url
      response = Net::HTTP.get_response(url)
      SearchResult.new response
    end

end
