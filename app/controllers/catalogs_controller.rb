# -*- encoding : utf-8 -*-
class CatalogsController < ApplicationController
  layout "lite_application"
  prepend_before_filter :verify_if_is_catalog
  helper_method :header
  DEFAULT_PAGE_SIZE = 48

  def show
    search_params = SeoUrl.parse(request.fullpath)

    Rails.logger.debug("New params: #{params.inspect}")

    # @campaign, @campaign_products = HighlightCampaign.campaign_products(params[:cmp])
    @campaign = HighlightCampaign.find_campaign(params[:cmp])

    page_size = params[:page_size] || DEFAULT_PAGE_SIZE
    @search = SearchEngine.new(search_params, true).for_page(params[:page]).with_limit(page_size)


    @url_builder = SeoUrl.new(search_params, "category", @search)
    @antibounce_box = AntibounceBox.new(params) if AntibounceBox.need_antibounce_box?(@search, @search.expressions["brand"].map{|b| b.downcase}, params)

    @search.for_admin if current_admin
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
    @pixel_information = @category = params[:category]
    @cache_key = "catalogs#{request.path}|#{@search.cache_key}#{@campaign.cache_key}"
    @category = @search.expressions[:category].first
    params[:category] = @search.expressions[:category].first
    expire_fragment(@cache_key) if params[:force_cache].to_i == 1
  end

  private

    def header
      @header ||= CatalogHeader::CatalogBase.for_url(request.path).first
    end

    def title_text
      if header && header.title_text.present?
        Seo::SeoManager.new(request.path, model: header).select_meta_tag
      else
        Seo::SeoManager.new(request.path, search: @search).select_meta_tag
      end
    end

    def verify_if_is_catalog
      #TODO Please remove me when update Rails version
      #We can use constraints but this version (3.2.13) has a bug

      if (/^(sapato|bolsa|acessorio|roupa)/ =~ params[:category]).nil?
        render :template => "/errors/404.html.erb", :layout => 'error', :status => 404, :layout => "lite_application"
      end
    end
end
