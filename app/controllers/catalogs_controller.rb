# -*- encoding : utf-8 -*-
class CatalogsController < ApplicationController
  layout "lite_application"
  prepend_before_filter :verify_if_is_catalog

  def show
    search_params = SeoUrl.parse(params)
    Rails.logger.debug("New params: #{params.inspect}")

    if params[:cmp].present? && @campaign = HighlightCampaign.find_by_label(params[:cmp])
      @campaign_products = SearchEngine.new(product_id: @campaign.product_ids).with_limit(1000)
    end

    if params[:smart].present?
      @search = SearchEngine.new(search_params, true).for_page(params[:page]).with_limit(48)
    else
      @search = SearchEngine.new(search_params).for_page(params[:page]).with_limit(48)
    end

    @url_builder = SeoUrl.new(search_params, "category", @search)
    @antibounce_box = AntibounceBox.new(params) if AntibounceBox.need_antibounce_box?(@search, @search.expressions["brand"].map{|b| b.downcase}, params)

    @search.for_admin if current_admin
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
    @pixel_information = @category = params[:category]
    @cache_key = "catalogs#{request.path}|#{@search.cache_key}#{@campaign_products.cache_key if @campaign_products}"
    expire_fragment(@cache_key) if params[:force_cache].to_i == 1

    @header = CatalogHeader::CatalogBase.for_url(request.path)
  end

  private
    def verify_if_is_catalog
      #TODO Please remove me when update Rails version
      #We can use constraints but this version (3.2.13) has a bug

      if (/^(sapato|bolsa|acessorio|roupa)/ =~ params[:category]).nil?
        render :template => "/errors/404.html.erb", :layout => 'error', :status => 404, :layout => "lite_application"
      end
    end
end
