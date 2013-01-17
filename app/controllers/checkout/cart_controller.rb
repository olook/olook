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
      notify_promotion_listener @cart
    else
      notice_message = @cart.errors.messages.values.flatten.first
      render :error, :locals => { :notice => notice_message }
    end

  end

  def find_suggested_product
    ids = Setting.recommended_products.split(",").map {|product_id| product_id.to_i}
    products = Product.find ids
    products.shuffle.first if products
  end

  private 
    def notify_promotion_listener cart
      PromotionListener.update cart
    end  
end
