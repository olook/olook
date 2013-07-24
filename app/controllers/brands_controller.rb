class BrandsController < SearchController
  layout "lite_application"
  def index
  end

  def show
    search_params = SeoUrl.parse(params)
    Rails.logger.debug("New params: #{params.inspect}")

    @search = SearchEngine.new(search_params).for_page(params[:page]).with_limit(48)
    @search.for_admin if current_admin

    params.merge!(search_params)

    @brand = Brand.where(name: ActiveSupport::Inflector.transliterate(params[:brand]).downcase.titleize)

    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
    @url_builder = SeoUrl.new(search_params, "brand", @search)
  end
end
