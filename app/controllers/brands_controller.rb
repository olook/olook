class BrandsController < ApplicationController
  layout "lite_application"
  def index
    @url_builder = SeoUrl.new(path: request.fullpath, path_positions: '/marcas/:brand:/-:category::subcategory:-/-:care::color::size::heel:_')
    @search = SearchEngine.new
    @url_builder.set_search @search
  end

  def show
    @url_builder = SeoUrl.new(path: request.fullpath, path_positions: '/marcas/:brand:/-:category::subcategory:-/-:care::color::size::heel:_')
    search_params = @url_builder.parse_params
    if search_params['category'] == 'roupa'
      @url_builder.set_params('category', 'roupa')
    end
    @campaign = HighlightCampaign.find_campaign(params[:cmp])
    @search = SearchEngine.new(search_params).for_page(params[:page]).with_limit(48)
    @search.for_admin if current_admin
    @url_builder.set_search @search

    @brand = Brand.where(name:  params[:brand].to_s.split("-").map{|brand| ActiveSupport::Inflector.transliterate(brand).downcase.titleize})
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
  end
  private
    def canonical_link
      brand = Array(@brand).first
      if brand
        "http://#{request.host_with_port}/#{brand.name.downcase}"
      end
    end
end
