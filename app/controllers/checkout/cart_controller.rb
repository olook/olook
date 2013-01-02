# -*- encoding : utf-8 -*-
class Checkout::CartController < Checkout::BaseController
  layout "site"

  respond_to :html, :js
  before_filter :erase_freight

  def show
    @google_path_pixel_information = "Carrinho"
    @report  = CreditReportService.new(@user)
    @url = request.protocol + request.host
    @url += ":" + request.port.to_s if request.port != 80
    @lookbooks = Lookbook.active.all
    @suggested_product = find_suggested_product
    @promotion_free_item = Promotion.find_by_strategy("free_item_strategy")
  end

  def destroy
    @cart.destroy
    clean_cart!
    redirect_to cart_path, notice: "Sua sacola está vazia"
  end

  def update

    if @cart.update_attributes(params[:cart])
      render :json => true
    else
      render :json => true, :status => :unprocessable_entity
    end

  end


  # TODO maybe put this logic inside Cart model !?! And them return this message...
  # Any more thoughts ?
  def update_coupon
    code = params[:coupon][:code] if params[:coupon]
    coupon = Coupon.find_by_code(code)
    response_message = if coupon.try(:expired?)
      session[:cart_coupon] = nil
      "Cupom expirado. Informe outro por favor"
    elsif coupon.try(:available?)
      session[:cart_coupon] = coupon
      "Cupom atualizado com sucesso"
    else
      session[:cart_coupon] = nil
      "Cupom inválido"
    end

    redirect_to cart_path, :notice => response_message
  end

  def remove_coupon
    response_message = session[:cart_coupon] ? "Cupom removido com sucesso" : "Você não está usando cupom"
    session[:cart_coupon] = nil
    redirect_to cart_path, :notice => response_message
  end

  def update_credits
    session[:cart_use_credits] = params[:use_credit] && params[:use_credit][:value] == "1"
    @cart_service.credits = session[:cart_use_credits]
  end

  def find_suggested_product
    ids = Setting.recommended_products.split(",").map {|product_id| product_id.to_i} 
    products = Product.find ids
    products.shuffle.first if products
  end
end

