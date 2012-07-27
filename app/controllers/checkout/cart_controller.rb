# -*- encoding : utf-8 -*-
class Checkout::CartController < Checkout::BaseController
  # layout "site"

  respond_to :html, :js
  before_filter :erase_freight

  def show
    @bonus = @user ? @user.credits_for?(session[:cart_credits]) : 0
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
          format.js { render :error, locals: { notice: notice_response } }
          format.html { redirect_to(cart_path, notice: notice_response) }
        end
      end
    else
      respond_with do |format|
        format.js { render :error, :locals => { :notice => "Por favor, selecione os atributos do produto." }}
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

  def remove_credits
    msg = "Você não está usando nenhum crédito"
    msg = "Créditos removidos com sucesso" if @cart_service.credits > 0
    session[:cart_credits] = 0
    redirect_to cart_path, :notice => msg
  end

  def update_credits
    credits = if params[:credits] && params[:credits][:value]
      params[:credits][:value].gsub!(",",".")
      BigDecimal.new(params[:credits][:value].to_s)
    end
    
    credits ||= 0
    
    if @user.can_use_credit?(credits)
      @cart_service.credits = credits
      session[:cart_credits] = @cart_service.credits_discount
      if credits > session[:cart_credits]
        msg = "Você tentou utilizar mais que o permitido para esta compra, utilizamos o máximo permitido."
      else
        msg = "Créditos atualizados com sucesso"
      end
    else
      msg = "Você não tem créditos suficientes"
    end

    redirect_to cart_path, :notice => msg
  end
end

