# -*- encoding : utf-8 -*-
require 'new_relic/agent/method_tracer'

class CatalogsController < ApplicationController
  include ::NewRelic::Agent::MethodTracer

  layout "lite_application"
  prepend_before_filter :verify_if_is_catalog
  helper_method :header

  DEFAULT_PAGE_SIZE = 32

  def add_campaign(params)
    HighlightCampaign.find_campaign(params[:cmp])
  end

  def not_found
    @campaign = add_campaign(params)
    @url_builder = SeoUrl.new(path: request.fullpath,
                      path_positions: '/:category:/-:subcategory::brand:-/-:care::color::size::heel:_',
                      params: { category: params[:category] })
    @search = add_search_result(@url_builder.parse_params, params)
    @url_builder.set_search(@search)
    @category = @search.filter_value(:category).to_a.first.downcase
  end

  def add_search_result(search_params, params)
    search_params[:limit] = params[:page_size] || DEFAULT_PAGE_SIZE
    search_params[:page] = params[:page]
    search_params[:admin] = !!current_admin
    SearchEngine.new(search_params, is_smart: true)
  end

  def index

    default_params = {
      category: params[:category],
    }
    
    # Se nao houver ordenacao, roda o teste A/B
    if params[:por].blank? || params[:por] == "0"
      variation = ab_test("catalog_sorting_test", "default", "by_discount")
      if variation == 'by_discount'
        default_params[:sort] = "-desconto" 
      end
    end


    @campaign = add_campaign(params)
    @url_builder = SeoUrl.new(path: request.fullpath,
                      path_positions: '/:category:/-:subcategory::brand:-/-:care::color::size::heel:_',
                      params: default_params)

    search_params = @url_builder.parse_params
    @search = add_search_result(search_params, params)
    @url_builder.set_search(@search)
    redirect_to catalog_not_found_path if @search.products.size == 0
    @chaordic_user = ChaordicInfo.user(current_user, cookies[:ceid])
    @pixel_information = @category = params[:category]
    @color = search_params["color"]
    @size = search_params["size"]
    @brand_name = search_params["brand"]
    @cache_key = "catalogs#{request.path}|#{@search.cache_key}#{@campaign.cache_key}"
    @category = @search.filter_value(:category).to_a.first.to_s.downcase
    @subcategory = @search.filter_value(:subcategory).to_a.first
    params[:category] = @search.filter_value(:category).to_a.first

    key = [@search.filter_value(:category).first]
    key.push(@search.filter_value(:subcategory).first) unless @search.filter_value(:subcategory).blank?
    @leaderboard = Leaderboard.new(key: key.join(':'))

    expire_fragment(@cache_key) if params[:force_cache].to_i == 1
  end

  add_method_tracer :parse_parameters_from, 'Custom/CatalogsController/parse_parameters_from'
  add_method_tracer :add_campaign, 'Custom/CatalogsController/add_campaign'
  add_method_tracer :add_search_result, 'Custom/CatalogsController/add_search_result'

  private

    def canonical_link
      host =  "http://#{request.host_with_port}/"
      if @subcategory
        "#{host}#{@category}/#{@subcategory.downcase}"
      else
        "#{host}#{@category}"
      end
    end

    def verify_if_is_catalog
      #TODO Please remove me when update Rails version
      #We can use constraints but this version (3.2.13) has a bug

      if (/^(sapato|bolsa|acessorio|roupa|curves)/ =~ params[:category]).nil?
        render :template => "/errors/404.html.erb", :layout => 'error', :status => 404, :layout => "lite_application"
      end
    end  
end
