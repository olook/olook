# -*- encoding : utf-8 -*-
class CartBuilder
  def self.gift(controller)
    GiftCartBuilder.new(controller).build
  end
  
  #TODO: EXTRACT TO CLASS
  class GiftCartBuilder
    def self.calculate_gift_prices order
      return if !order.restricted? || order.line_items.empty?
      position = 0
      order.reload
      order.line_items.each do |line_item|
        line_item.update_attributes :retail_price => line_item.variant.gift_price(position)
        position += 1
      end
    end

    def initialize controller
      @controller = controller
      @gift_products = controller.session[:gift_products]
      @order = controller.current_order
      @user = controller.current_user
    end

    def build
      if @gift_products && @order
        set_as_restricted
        set_gift_session_stuff
        add_products_to_cart
        GiftCartBuilder.calculate_gift_prices(@order)
        clear_gift_products_session
        set_flash_notice
        @controller.cart_path
      else
        redirect_back
      end
    end

    def redirect_back
      @controller.flash[:notice] = "Produtos não foram adicionados"
      :back
    end

    def set_gift_session_stuff
      set_occasion
      set_recipient
    end

    def set_occasion
      GiftOccasion.find(@controller.session[:occasion_id]).update_attributes(:user_id => @user.id) if @controller.session[:occasion_id]
    end

    def set_recipient
      GiftRecipient.find(@controller.session[:recipient_id]).update_attributes(:user_id => @user.id) if @controller.session[:recipient_id]
    end

    def set_as_restricted
      @order.update_attributes :restricted => true if !@order.restricted?
      @order.line_items.destroy_all
    end

    def add_products_to_cart
      @gift_products.each_pair do |k, id|
        variant = Variant.find(id)
        line_item = @order.add_variant(variant, nil) if variant
      end
    end

    def set_flash_notice
      @controller.flash[:notice] = if @order.line_items.size > 0
        "Produtos adicionados com sucesso"
      else
        "Um ou mais produtos selecionados não estão disponíveis"
      end
    end

    def clear_gift_products_session
      @controller.session[:gift_products] = nil
    end
  end

end
