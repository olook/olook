# -*- encoding : utf-8 -*-
class CartController < ApplicationController
  layout "checkout"

  respond_to :html, :js

  def show
    # @bonus = @user.current_credit - @order.credits
    # @cart = CartPresenter.new(@order)
    # @line_items = @order.line_items
    # @coupon_code = @order.used_coupon.try(:code)
    # unless @coupon_code
    #   PromotionService.new(current_user, @order).apply_promotion if @promotion
    # end
  end

  def destroy
    # @order.destroy
    # session[:order] = nil
    # redirect_to cart_path, :notice => "Sua sacola está vazia"
  end

  def update
    # respond_with do |format|
    #   if @order.remove_variant(@variant)
    #     destroy_freight(@order)
    #     destroy_order_if_the_cart_is_empty(@order) if !@order.restricted?
    #     CartBuilder::GiftCartBuilder.calculate_gift_prices(@order)
    #     format.html { redirect_to cart_path, :notice => "Produto removido com sucesso" }
    #     format.js { head :ok }
    #   else
    #     format.js { head :not_found }
    #     format.html { redirect_to cart_path, :notice => "Este produto não está na sua sacola" }
    #   end
    # end
  end

  def create
    # @order.update_attributes :restricted => false if @order.restricted? && @order.line_items.empty?
    # 
    # if @order.restricted?  # gift cart
    #   return respond_with do |format|
    #     format.js { render :error, :locals => { notice: "Produtos de presente não podem ser comprados com produtos da vitrine" }}
    #     format.html { redirect_to(cart_path, notice: "Produtos de presente não podem ser comprados com produtos da vitrine") }
    #   end
    # end
    # 
    # if @order.add_variant(@variant, nil)
    #   destroy_freight(@order)
    #   respond_with do |format|
    #     format.html do
    #       if request.xhr?
    #         render partial: "shared/cart_line_item", locals: { item: @order.line_items.detect { |li| li.variant_id == @variant.id }, hidden: true }, :layout => false, status: :created
    #       else
    #         redirect_to(cart_path, :notice => "Produto adicionado com sucesso")
    #       end
    #     end
    #   end
    # else
    #   respond_with do |format|
    #     format.js { head :not_found, status: :unprocessable_entity }
    #     format.html { redirect_to(:back, :notice => "Produto esgotado") }
    #   end
    # end
  end
end

