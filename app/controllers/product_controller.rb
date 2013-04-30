# -*- encoding : utf-8 -*-
class ProductController < ApplicationController
  respond_to :html
  before_filter :load_show_product, only: [:show, :spy]


  rescue_from ActiveRecord::RecordNotFound do
    render :template => "/errors/404.html.erb", :layout => 'error', :status => 404
  end

  def show
  end

  def spy
    render layout: 'application'
  end

  def share_by_email
    name_and_emails = params.slice(:name_from, :email_from, :emails_to_deliver)
    @product = Product.find(params[:product_id])
    @product.share_by_email(name_and_emails)
    #redirect_to(:back, notice: "Emails enviados com sucesso!")
  end

  private
  def load_show_product
    @google_path_pixel_information = "Produto"
    @facebook_app_id = FACEBOOK_CONFIG["app_id"]
    @url = request.protocol + request.host

    @product = if current_admin
      Product.find(params[:id])
    else
      Product.only_visible.find(params[:id])
    end

    @google_pixel_information = @product
    @chaordic_user = ChaordicInfo.user current_user
    @chaordic_product = ChaordicInfo.product @product
    @chaordic_category = @product.category_humanize
    @variants = @product.variants

    @gift = (params[:gift] == "true")
    @only_view = (params[:only_view] == "true")
    @shoe_size = params[:shoe_size].to_i
  end
end
