# -*- encoding : utf-8 -*-
require 'new_relic/agent/method_tracer'

class ProductController < ApplicationController
  include ::NewRelic::Agent::MethodTracer 

  respond_to :html
  before_filter :load_show_product, :load_product_discount_service, only: [:show, :spy, :product_valentines_day]
  prepend_before_filter :assign_valentines_day_parameters, only: [:product_valentines_day]

  rescue_from ActiveRecord::RecordNotFound do
    ### to render home partials ###
    @stylist = Product.fetch_products :selection
    render :template => "/errors/404.html.erb", :layout => 'error', :status => 404, :layout => "lite_application"
  end

  def show
    @ab_test_parameter = params[:s] == "1" ? 1 : 0
    # render layout: "lite_application"
  end

  def product_valentines_day
    @uid = params[:encrypted_id]
    # girlfriend = User.find_by_id(IntegerEncoder.decode(params[:encrypted_id]))
    # @user_data = FacebookAdapter.new(girlfriend.facebook_token).retrieve_user_data
  end

  def spy
    @hide_shipping = params[:from] == 'cart'
    render layout: nil
  end

  def share_by_email
    name_and_emails = params.slice(:name_from, :email_from, :emails_to_deliver)
    @product = Product.find(params[:product_id])
    @product.share_by_email(name_and_emails)
    #redirect_to(:back, notice: "Emails enviados com sucesso!")
  end


  def load_product_discount_service
    @product_discount_service = ProductDiscountService.new(@product, cart: @cart, coupon: @cart.coupon, promotion: Promotion.select_promotion_for(@cart))
  end

  def load_show_product
    @google_path_pixel_information = "product"
    @facebook_app_id = FACEBOOK_CONFIG["app_id"]
    @url = request.protocol + request.host

    product_name = params[:id]
    product_id = product_name.split("-").last.to_i
    @product = if current_admin
      Product.find(product_id)
    else
      p = Product.only_visible.find(product_id)
      raise ActiveRecord::RecordNotFound unless p.price > 0
      p
    end

    @google_pixel_information = @product
    @chaordic_user = ChaordicInfo.user(current_user,cookies[:ceid])
    @chaordic_product = ChaordicInfo.product @product
    @chaordic_category = @product.category_humanize
    @variants = @product.variants

    @gift = (params[:gift] == "true")
    @only_view = (params[:only_view] == "true")
    @shoe_size = @user.try(:shoes_size) || params[:shoe_size].to_i
  end

  def title_text 
    Seo::SeoManager.new(request.path, model: @product).select_meta_tag
  end

  def canonical_link
    return product_seo_path(@product.all_colors.first.seo_path) unless (@product.try(:all_colors).nil? || @product.try(:all_colors).empty?) 
    product_seo_path(@product.seo_path) if @product
  end


  # Custom metrics for new relic
  add_method_tracer :load_show_product, 'Custom/ProductController/load_show_product'
  add_method_tracer :load_product_discount_service, 'Custom/ProductController/load_product_discount_service'
  add_method_tracer :title_text, 'Custom/ProductController/title_text'
  add_method_tracer :canonical_link, 'Custom/ProductController/canonical_link'


  private

    def assign_valentines_day_parameters
      params[:coupon_code] = Setting.valentines_day_coupon_code
      params[:modal] = Setting.valentines_day_show_modal
    end

end
