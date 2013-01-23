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
    @chaordic_cart = ChaordicInfo.cart @cart, current_user
  end

  def destroy
    @cart.destroy
    clean_cart!
    redirect_to cart_path, notice: "Sua sacola está vazia"
  end

  def update
    unless @cart.update_attributes(params[:cart])
      notice_message = @cart.errors.messages.values.flatten.first
      render :error, :locals => { :notice => notice_message }
    end
  end

  private
    # TODO => Consider moving this logic to Product class
    def find_suggested_product
      suggested_products_with_inventory.shuffle.first
    end

    def suggested_products_with_inventory
      ids = Setting.recommended_products.split(",").map {|product_id| product_id.to_i}
      products = Product.find ids
      products.delete_if {|product| product.inventory < 1}
    end

end
