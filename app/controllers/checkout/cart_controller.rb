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

    if @cart.update_attributes(params[:cart])
      render :json => true
    else
      render :json => true, :status => :unprocessable_entity
    end

  end

  def create
    variant_id = params[:variant][:id] if params[:variant]
    variant_quantity = params[:variant][:quantity] if  params[:variant]

    if @variant = Variant.find_by_id(variant_id)
      if @cart.add_item(@variant, variant_quantity)
        respond_with do |format|
          message = variant_quantity.nil? ? "Produto adicionado com sucesso" : "Carrinho atualizado com sucesso"
          format.html { redirect_to(cart_path, notice: message) }
        end
      else
        respond_with(@cart) do |format|
          notice_response = "Produto esgotado"
          notice_response = "Produtos de presente não podem ser comprados com produtos da vitrine" if @cart.has_gift_items?
          format.js { render :error, locals: { notice: notice_response } }
          format.html { redirect_to(cart_path, notice: notice_response) }
        end
      end
    else
      respond_with do |format|
        format.js { render :error, :locals => { :notice => "Por favor, selecione o tamanho do produto." }}
        format.html { redirect_to(:back, :notice => "Produto não disponível para esta quantidade ou inexistente") }
      end
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
    Product.find(Setting.checkout_suggested_product_id.to_i) if Setting.checkout_suggested_product_id
  end
end

