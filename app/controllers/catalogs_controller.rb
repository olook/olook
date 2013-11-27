# -*- encoding : utf-8 -*-
require 'new_relic/agent/method_tracer'

class CatalogsController < ApplicationController
  include ::NewRelic::Agent::MethodTracer

  layout "lite_application"
  prepend_before_filter :verify_if_is_catalog
  helper_method :header
  DEFAULT_PAGE_SIZE = 48

  def parse_parameters_from request
    SeoUrl.parse(request.fullpath)
  end

  def add_campaign(params)
    HighlightCampaign.find_campaign(params[:cmp])  
  end

  def add_search_result(search_params, params)
    page_size = params[:page_size] || DEFAULT_PAGE_SIZE
    search = SearchEngineWithDynamicFilters.new(search_params, true)
      .for_page(params[:page])
      .with_limit(page_size)

    search.for_admin if current_admin
    search
  end

  def add_antibounce_box(search, params)
    brands = search.expressions["brand"].map{|b| b.downcase}
    if AntibounceBox.need_antibounce_box?(@search, brands, params)      
      @antibounce_box = AntibounceBox.new(params) 
    end
  end

  def show
    search_params = parse_parameters_from request
    Rails.logger.debug("New params: #{params.inspect}")

    @campaign = add_campaign(params)
    @search = add_search_result(search_params, params)

    @url_builder = SeoUrl.new(search_params, "category", @search)

    add_antibounce_box(@search, params)

    
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
    @pixel_information = @category = params[:category]
    @cache_key = "catalogs#{request.path}|#{@search.cache_key}#{@campaign.cache_key}"
    @category = @search.expressions[:category].first
    params[:category] = @search.expressions[:category].first
    expire_fragment(@cache_key) if params[:force_cache].to_i == 1
  end

  add_method_tracer :parse_parameters_from, 'Custom/CatalogsController/parse_parameters_from'
  add_method_tracer :add_campaign, 'Custom/CatalogsController/add_campaign'
  add_method_tracer :add_search_result, 'Custom/CatalogsController/add_search_result'
  add_method_tracer :add_antibounce_box, 'Custom/CatalogsController/add_antibounce_box'

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
