# -*- encoding : utf-8 -*-
class CartController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_product_variant, :only => [:create, :edit]
  before_filter :current_order

  def show
  end

  def update
    if @order.remove_variant(@variant)
      redirect_to cart_path, :notice => "Produto removido com sucesso"
    else
      redirect_to cart_path, :notice => "Este produto não está na sua sacola"
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
    @order = (session[:order] ||= @user.orders.create)
  end

  def load_user
    @user = current_user
  end
end

