# -*- encoding : utf-8 -*-
class Checkout::CartController < Checkout::BaseController
  layout "site"

  respond_to :html, :js
  before_filter :erase_freight

  def show
    report  = CreditReportService.new(@user)
    @amount_of_loyalty_credits = report.amount_of_loyalty_credits
    @amount_of_invite_credits = report.amount_of_invite_credits
    @redeem_credits  = report.amount_of_redeem_credits
    @used_credits = report.amount_of_used_credits
    @url = request.protocol + request.host
    @url += ":" + request.port.to_s if request.port != 80
  end

  def destroy
    @cart.destroy
    clean_cart!
    redirect_to cart_path, notice: "Sua sacola está vazia"
  end

  def update
    variant_id = params[:variant][:id] if params[:variant]

    respond_with do |format|
      if @cart.remove_item(Variant.find_by_id(variant_id))
        format.html { redirect_to cart_path, notice: "Produto removido com sucesso" }
        format.js { head :ok }
      else
        format.js { head :not_found }
        format.html { redirect_to cart_path, notice: "Este produto não está na sua sacola" }
      end
    end
  end

  def create
    variant_id = params[:variant][:id] if params[:variant]


    if @variant = Variant.find_by_id(variant_id)
      if @cart.add_item(@variant)
        respond_with do |format|
          format.html { redirect_to(cart_path, notice: "Produto adicionado com sucesso") }
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

  def update_gift_wrap
    session[:gift_wrap] = params[:gift][:gift_wrap] if params[:gift] && params[:gift][:gift_wrap]
    render :json => true
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
end

