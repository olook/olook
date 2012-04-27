# -*- encoding : utf-8 -*-
class CartController < ApplicationController
  layout "checkout"

  respond_to :html, :js
  before_filter :verify_login, :only => [:add_products_to_gift_cart]
  before_filter :authenticate_user!, :except => [:add_products_to_gift_cart]
  before_filter :load_user
  before_filter :check_early_access
  before_filter :check_product_variant, :only => [:create, :update, :update_quantity_product]
  before_filter :current_order
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

  def update_coupon
    code = params[:coupon][:code]
    coupon_manager = CouponManager.new(@order, code)
    response_message = coupon_manager.apply_coupon
    redirect_to cart_path, :notice => response_message
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
      @order.update_attributes(:credits => credits)
      destroy_freight(@order)
      redirect_to cart_path, :notice => "Créditos atualizados com sucesso"
    else
      redirect_to cart_path, :notice => "Você não tem créditos suficientes"
    end
  end

  def show
    @bonus = @user.current_credit - @order.credits
    @cart = Cart.new(@order)
    @line_items = @order.line_items
    @coupon_code = @order.used_coupon.try(:code)
    unless @coupon_code
      PromotionService.new(current_user, @order).apply_promotion if @promotion
    end
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
        calculate_gift_prices(@order)
        format.html do
          redirect_to cart_path, :notice => "Produto removido com sucesso"
        end
        format.js do
          head :ok
        end
      else
        format.js do
          head :not_found
        end
        format.html do
          redirect_to cart_path, :notice => "Este produto não está na sua sacola"
        end
      end
    end
  end

  def update_quantity_product
   destroy_freight(@order) if @order.add_variant(@variant, params[:variant][:quantity])
   redirect_to(cart_path, :notice => "Quantidade atualizada")
  end

  def create
    @order.update_attributes :restricted => false if @order.restricted? && @order.line_items.empty?

    if !@order.restricted?  # gift cart
      if @order.add_variant(@variant, nil)
        destroy_freight(@order)
        redirect_to(cart_path, :notice => "Produto adicionado com sucesso")
      else
        redirect_to(:back, :notice => "Produto esgotado")
      end
    else
      redirect_to(cart_path, :notice => "Produtos de presente não podem ser comprados com produtos da vitrine")
    end
  end
  
  def add_products_to_gift_cart
    session[:gift_products] = params[:products]
    if session[:gift_products] && @order
      @order.update_attributes :restricted => true if !@order.restricted?
      @order.line_items.destroy_all
      
      # to get shoe size
      @gift_recipient = GiftRecipient.find(session[:recipient_id])
      
      # add products to cart
      session[:gift_products].each_pair do |k, id|
        product = Product.find(id)
        if product
          variant = case product.category
            when Category::SHOE then
              product.variants.where(:display_reference => "size-#{@gift_recipient.shoe_size}").first
            # when Category::BAG then
            #   product.variants.last
            # when Category::ACCESSORY then
            #   product.variants.last
            else
              product.variants.last
          end
        else
          variant = Variant.find(id)
        end
        
        line_item = @order.add_variant(variant, nil, @order.gift_wrap?) if variant
      end
      calculate_gift_prices(@order)
      
      total_products = @order.line_items.size
      redirect_to(cart_path, :notice => total_products > 0 ? "Produtos adicionados com sucesso" : "Um ou mais produtos selecionados não estão disponíveis")
    else
      redirect_to(:back, :notice => "Produtos não foram adicionados")
    end
  end
  
  # needs testing
  def calculate_gift_prices order
    return if !order.restricted? || order.line_items.empty?
    position = 0
    order.reload
    order.line_items.each do |line_item|
      line_item.update_attributes :retail_price => line_item.variant.gift_price(position)
      position += 1
    end
  end

  private

  def clear_gifts_in_the_order(order)
    order.reload
    order.clear_gift_in_line_items
  end

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
    redirect_to(:back, :notice => "Produto não disponível para esta quantidade ou inexistente") unless @variant.try(:available_for_quantity?)
  end

  def current_order
    if params[:order_id] && params[:auth_token]
      @user.authentication_token = nil
      @user.save
      session[:order] = params[:order_id]
      @order = Order.find(params[:order_id])
      if @order.user != @user
        session[:order] = nil
        @order = nil
        redirect_to root_path
      else
        redirect_to root_path unless @order.state == "in_the_cart" && @order.disable == false
      end
    else
      order_id = (session[:order] ||= @user.orders.create.id)
      @order = @user.orders.find(order_id)
      @order.update_attribute( "in_cart_notified", true ) unless !current_admin
    end
  end

  def load_user
    @user = current_user
  end
  
  def verify_login
    if not current_user and params[:products]
      session[:gift_products] = params[:products]
      redirect_to new_gift_user_session_path
    end
  end
end

