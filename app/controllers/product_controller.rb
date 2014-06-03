# -*- encoding : utf-8 -*-
require 'new_relic/agent/method_tracer'

class ProductController < ApplicationController
  include ::NewRelic::Agent::MethodTracer 
  include ProductsHelper

  respond_to :html
  before_filter :load_show_product, :load_product_discount_service, only: [:show, :spy, :product_valentines_day]
  prepend_before_filter :assign_valentines_day_parameters, only: [:product_valentines_day]

  rescue_from ActiveRecord::RecordNotFound do
    ### to render home partials ###
    @stylist = Product.fetch_products :selection
    render :template => "/errors/404.html.erb", :layout => 'error', :status => 404, :layout => "lite_application"
  end

  def show
    render layout: "lite_application"
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
    name_and_emails = params.slice(:name_from, :email_from, :emails_to_deliver, :email_body)
    @product = Product.joins(:details).find(params[:product_id])
    @product.share_by_email(name_and_emails)
    #redirect_to(:back, notice: "Emails enviados com sucesso!")
  end

  def load_product_discount_service
    coupon = @cart.try(:coupon) 
    @product_discount_service = ProductDiscountService.new(@product, cart: @cart, coupon: coupon, promotion: Promotion.select_promotion_for(@cart))
    @product_discount_service.calculate
  end

  def load_show_product
    @google_path_pixel_information = "product"
    @facebook_app_id = FACEBOOK_CONFIG["app_id"]
    product_name = params[:id]
    product_id = product_name.split("-").last.to_i
    @product = if current_admin
      Product.includes(:details).find(product_id)
    else
      p = Product.joins(:details).includes(:details).only_visible.find(product_id)
      raise ActiveRecord::RecordNotFound unless p.price > 0
      p
    end

    unless @current_admin
      Leaderboard.new(key: "#{@product.category_humanize.to_s.parameterize}:#{@product.subcategory.to_s.parameterize}").score(@product.id)
    end

    @google_pixel_information = @product
    @chaordic_category = @product.category_humanize
    @variants = @product.variants

    @shoe_size = @user.try(:shoes_size) || params[:shoe_size].to_i

    create_cart if @product.related_products.any?
    @details = @product.details.only_specification.with_valid_values.to_a.select do |d|
      if d.translation_token == "Detalhes"
        @product_detail_info ||= d
        false
      else
        true
      end
    end
    if @product_detail_info
      product_detail = Product::GuidesService.new(@product_detail_info.description)
      @new_detail = product_detail.new_style?
      @size_detail = product_detail.parse
    end
  end

  def canonical_link
    return "http://#{request.host_with_port}#{product_seo_path(@product.all_colors.first.seo_path)}" unless @product.try(:all_colors).blank?
    "http://#{request.host_with_port}#{product_seo_path(@product.seo_path)}" if @product
  end

  # Custom metrics for new relic
  add_method_tracer :load_show_product, 'Custom/ProductController/load_show_product'
  add_method_tracer :load_product_discount_service, 'Custom/ProductController/load_product_discount_service'
  add_method_tracer :title_text, 'Custom/ProductController/title_text'
  add_method_tracer :canonical_link, 'Custom/ProductController/canonical_link'

  def meta_description
    modify_meta_description(@product.try(:description), @product.try(:product_color))
  end

  private

    def assign_valentines_day_parameters
      params[:coupon_code] = Setting.valentines_day_coupon_code
      params[:modal] = Setting.valentines_day_show_modal
    end

end
