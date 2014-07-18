module Api
  module V1
    class CurrentCartsController < ApiBasicController
      skip_before_filter  :verify_authenticity_token
      def show
        @cart = current_cart
        render json: (@cart ? @cart.api_hash : {})
      end

      def update
        @cart = current_cart || Cart.new
        if params[:current_cart]
          @cart.use_credits = params[:current_cart][:use_credits]
        end
        @cart.attributes = params[:cart]
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
