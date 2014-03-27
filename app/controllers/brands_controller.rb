class BrandsController < ApplicationController
  layout "lite_application"
  def index
  end

  def show
    @url_builder = SeoUrl.new(path: request.fullpath, path_positions: '/marcas/:brand:/-:category::subcategory:-/-:care::color::size::heel:_')
    Rails.logger.debug("New params: #{params.inspect}")

    @search = SearchEngine.new(@url_builder.parse_params).for_page(params[:page]).with_limit(48)
    @search.for_admin if current_admin
    @url_builder.set_search @search

    @brand = Brand.where(name:  params[:brand].to_s.split("-").map{|brand| ActiveSupport::Inflector.transliterate(brand).downcase.titleize})
    @antibounce_box = AntibounceBox.new(params) if @brand.any? && AntibounceBox.need_antibounce_box?(@search, @brand.map{|b| b.name.downcase}, params)
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
  end
  private
    def title_text
      Seo::SeoManager.new(request.path, model: @brand.try(:first), search: @search).select_meta_tag
    end

    def canonical_link
      brand = Array(@brand).first
      if brand
        "http://#{request.host_with_port}/#{brand.name.downcase}"
      end
    end
end
