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
  end

  def destroy
    @cart.destroy
    clean_cart!
    redirect_to cart_path, notice: "Sua sacola está vazia"
  end

  def update
    if params[:gift] && params[:gift][:gift_wrap]
      @cart.gift_wrap = params[:gift][:gift_wrap]
      @cart.save
      render :json => true
      return
    end

    variant_id = params[:variant][:id] if params[:variant]

    respond_with do |format|
      if @cart.remove_item(Variant.find_by_id(variant_id))
        format.html { redirect_to cart_path, notice: "Produto excluído com sucesso" }
        format.js { head :ok }
      else
        format.js { head :not_found }
        format.html { redirect_to cart_path, notice: "Produto excluído com sucesso" }
      end
    end
  end

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
    Product.find(Setting.checkout_suggested_product_id.to_i) if Setting.checkout_suggested_product_id
  end
end

