class BrandsController < SearchController
  layout "lite_application"
  def index
  end

  def show
    search_params = SeoUrl.parse(params)
    Rails.logger.debug("New params: #{params.inspect}")

    @filters = create_filters

    @side_filters = create_filters(true)

    @search = SearchEngine.new(search_params).for_page(params[:page]).with_limit(48)

    @brand = Brand.find_by_name(ActiveSupport::Inflector.transliterate(params[:brand]).downcase.titleize)
    @search.for_admin if current_admin
    @catalog_products = @search.products
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
  end
end
