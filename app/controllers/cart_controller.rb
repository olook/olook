# -*- encoding : utf-8 -*-
class CartController < ApplicationController
  layout "checkout"

  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_product_variant, :only => [:create, :update, :update_quantity_product]
  before_filter :current_order

  def update_bonus
    bonus = InviteBonus.calculate(@user)
    credits = params[:credits][:value]
    user_can_use_bonus = bonus >= credits.to_i
    if user_can_use_bonus
      @order.update_attributes(:credits => credits)
      redirect_to cart_path, :notice => "Créditos atualizados com suceso"
    else
      redirect_to cart_path, :notice => "Você não tem créditos suficientes"
    end
  end

  def show
    @bonus = InviteBonus.calculate(@user)
    @cart = Cart.new(@order)
  end

  def destroy
    @order.destroy
    session[:order] = nil
    redirect_to cart_path, :notice => "Sua sacola está vazia"
  end

  def update
    notice = @order.remove_variant(@variant) ? "Produto removido com sucesso" : "Este produto não está na sua sacola"
    redirect_to cart_path, :notice => notice
  end

  def update_quantity_product
   if @order.add_variant(@variant, params[:variant][:quantity])
      redirect_to(cart_path, :notice => "Quantidade atualizada")
    else
      redirect_to(:back, :notice => "Produto esgotado")
    end
  end

  def create
    if @order.add_variant(@variant)
      redirect_to(product_path(@variant.product), :notice => "Produto adicionado com sucesso")
    else
      redirect_to(:back, :notice => "Produto esgotado")
    end
  end

  private

  def check_product_variant
    variant_id = params[:variant][:id] if  params[:variant]
    @variant = Variant.find_by_id(variant_id)
    redirect_to(:back, :notice => "Selecione um tamanho") unless @variant
  end

  def current_order
    order_id = (session[:order] ||= @user.orders.create.id)
    @order = @user.orders.find(order_id)
  end

  def load_user
    @user = current_user
  end
end

