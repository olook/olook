module Api
  module V1
    class CurrentCartsController < ApiBasicController
      def show
        @cart = current_cart
        render json: (@cart ? @cart.api_hash : {})
      end

      def create
        @cart = Cart.new
      end

      def update
        @cart = current_cart || Cart.new
        @cart.attributes = params[:current_cart]
        
        if @cart.save
          render json: @cart.api_hash
        else
          render json: { errors: @cart.errors }, status: :unprocessable_entity
        end

      end

      private

      def current_cart
        @cart = Cart.find_saved_for_user(current_user, {session: session[:cart_id], params: params[:cart_id], coupon_code: params[:coupon_code]})
        session[:cart_id] = @cart.id if @cart
        @cart
      end
    end
  end
end
