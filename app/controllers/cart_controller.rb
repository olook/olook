# -*- encoding : utf-8 -*-
class CartController < ApplicationController
  layout "checkout"

  respond_to :html, :js
  before_filter :load_user
  before_filter :check_product_variant, :only => [:create, :update, :update_quantity_product]
  before_filter :load_order
  before_filter :verify_order_with_auth_token
  before_filter :format_credits_value, :only => [:update_bonus]

  def update_gift_data
    @order.update_attributes(params[:gift])
    if @order.gift_wrap?
      @order.gift_wrap_all_line_items
    else
      @order.clear_line_items_gift_wrapping
    end
    render :json => true
  end

  def update_coupon
    code = params[:coupon][:code]
    coupon_manager = CouponManager.new(@order, code)
    response_message = coupon_manager.apply_coupon
    redirect_to cart_path, :notice => response_message
  end

  def update_message
    @order.update_attributes(params[:gift])
    render :json => true
  end

  def remove_coupon
    coupon_manager = CouponManager.new(@order)
    response_message = coupon_manager.remove_coupon
    redirect_to cart_path, :notice => response_message
  end

  def remove_bonus
    if @order.credits > 0
      @order.update_attributes(:credits => nil)
      msg = "Créditos removidos com sucesso"
    else
      msg = "Você não está usando nenhum crédito"
    end
    redirect_to cart_path, :notice => msg
  end

  def update_bonus
    credits = BigDecimal.new(params[:credits][:value].to_s)
    if @user.current_credit >= credits && credits > 0
      @order.credits = credits
      @order.save
      destroy_freight(@order)
      if credits > @order.max_credit_value
        redirect_to cart_path, :notice => "Você tentou utilizar mais que o permitido para esta compra , utilizamos o máximo permitido."
      else
        redirect_to cart_path, :notice => "Créditos atualizados com sucesso"
      end
    else
      redirect_to cart_path, :notice => "Você não tem créditos suficientes"
    end
  end

  def show
    destroy_freight(@order)
    @bonus = @user.current_credit - @order.credits
    @cart = Cart.new(@order)
    @line_items = @order.line_items
    @coupon_code = @order.used_coupon.try(:code)
    # unless @coupon_code
    PromotionService.new(current_user, @order).apply_promotion if @promotion
    # end
  end

  def destroy
    @order.destroy
    session[:order] = nil
    redirect_to cart_path, :notice => "Sua sacola está vazia"
  end

  def update
    respond_with do |format|
      if @order.remove_variant(@variant)
        destroy_freight(@order)
        destroy_order_if_the_cart_is_empty(@order) if !@order.restricted?
        CartBuilder::GiftCartBuilder.calculate_gift_prices(@order)
        format.html { redirect_to cart_path, :notice => "Produto removido com sucesso" }
        format.js { head :ok }
      else
        format.js { head :not_found }
        format.html { redirect_to cart_path, :notice => "Este produto não está na sua sacola" }
      end
    end
  end

  def update_quantity_product
   destroy_freight(@order) if @order.add_variant(@variant, params[:variant][:quantity])
   redirect_to(cart_path, :notice => "Quantidade atualizada")
  end

  def create
    @order.update_attributes :restricted => false if @order.restricted? && @order.line_items.empty?

    if @order.restricted?  # gift cart
      return respond_with do |format|
        format.js { render :error, :locals => { notice: "Produtos de presente não podem ser comprados com produtos da vitrine" }}
        format.html { redirect_to(cart_path, notice: "Produtos de presente não podem ser comprados com produtos da vitrine") }
      end
    end

    if @order.add_variant(@variant, nil)
      destroy_freight(@order)
      respond_with do |format|
        format.html do
          if request.xhr?
            render partial: "shared/cart_line_item", locals: { item: @order.line_items.detect { |li| li.variant_id == @variant.id }, hidden: true }, :layout => false, status: :created
          else
            redirect_to(cart_path, :notice => "Produto adicionado com sucesso")
          end
        end
      end
    else
      respond_with do |format|
        format.js { head :not_found, status: :unprocessable_entity }
        format.html { redirect_to(:back, :notice => "Produto esgotado") }
      end
    end
  end

  private
  def destroy_freight(order)
    order.freight.destroy if order.freight
  end

  def destroy_order_if_the_cart_is_empty(order)
    if order.reload.line_items.empty?
      order.destroy
      session[:order] = nil
    end
  end

  def format_credits_value
    params[:credits][:value].gsub!(",",".")
  end

  def check_product_variant
    variant_id = params[:variant][:id] if params[:variant]
    @variant = Variant.find_by_id(variant_id)
    unless @variant.try(:available_for_quantity?)
      respond_with do |format|
        format.js { render :error, :locals => { :notice => "Por favor, selecione os atributos do produto." }}
        format.html { redirect_to(:back, :notice => "Produto não disponível para esta quantidade ou inexistente") }
      end
    end
  end

  def load_user
    @user = current_user
  end

  def verify_order_with_auth_token
    if params[:order_id] && params[:auth_token]
      if @order && !(@order.state == "in_the_cart" && !@order.disable)
        redirect_to root_path
      elsif @order.nil?
        session[:order] = nil
        redirect_to root_path
      end
    end
  end

  def load_order
    @order = current_order
  end
end

