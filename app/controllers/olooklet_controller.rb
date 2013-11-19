# -*- encoding : utf-8 -*-
class OlookletController < ApplicationController
  layout "lite_application"
  helper_method :header  
  DEFAULT_PAGE_SIZE = 48

  def index
    search_params = SeoUrl.parse(request.fullpath).merge({visibility: "#{Product::PRODUCT_VISIBILITY[:olooklet]}-#{Product::PRODUCT_VISIBILITY[:all]}"})
    Rails.logger.debug("New params: #{params.inspect}")    
    default_params(search_params,"olooklet", "olooklet")
  end

  private

  def default_params(search_params, site_section, cache_prefix)
    page_size = params[:page_size] || DEFAULT_PAGE_SIZE
    search_params[:skip_beachwear_on_clothes] = true
    @search = SearchEngine.new(search_params, true).for_page(params[:page]).with_limit(page_size)

    @url_builder = SeoUrl.new(search_params, site_section, @search)
    @antibounce_box = AntibounceBox.new(params) if AntibounceBox.need_antibounce_box?(@search, @search.expressions["brand"].map{|b| b.downcase}, params)

    @search.for_admin if current_admin
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
    @pixel_information = @category = params[:category]
    @cache_key = "olooklet#{request.path}|#{@search.cache_key}#{@campaign_products.cache_key if @campaign_products}"
    @category = @search.expressions[:category].first
    params[:category] = @search.expressions[:category].first
    expire_fragment(@cache_key) if params[:force_cache].to_i == 1        
  end

  def header
    @header ||= CatalogHeader::CatalogBase.for_url(request.path).first
    @header ||= CatalogHeader::CatalogBase.for_url("/olooklet-teste").first
  end

  def title_text
    "Outlet Online | Roupas Femininas e Sapatos Femininos | Olook"
  end

end

