# -*- encoding : utf-8 -*-
class CatalogsController < SearchController
  layout "lite_application"
  respond_to :html, :js

  helper_method :create_filters
  prepend_before_filter :verify_if_is_catalog

  def show
    search_params = SeoUrl.parse(params)
    Rails.logger.debug("New params: #{params.inspect}")

    if @campaign = HighlightCampaign.find_by_label(params[:cmp])
      @campaign_products = SearchEngine.new(product_ids: @campaign.product_ids).with_limit(1000)
    end

    @search = SearchEngine.new(search_params).for_page(params[:page]).with_limit(params[:per_page])
    @url_builder = SeoUrl.new(search_params, "category", @search)

    @search.for_admin if current_admin
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
    @pixel_information = params[:category]
    @cache_key = "#{@search.cache_key}#{@campaign_products.cache_key if @campaign_products}"
    expire_fragment(@cache_key) if params[:force_cache].to_i == 1
  end

  private
    def verify_if_is_catalog
      #TODO Please remove me when update Rails version
      #We can use constraints but this version has a bug

      if (/^(sapato|bolsa|acessorio|roupa)/ =~ params[:category]).nil?
        render :template => "/errors/404.html.erb", :layout => 'error', :status => 404, :layout => "lite_application"
      end
    end
end
