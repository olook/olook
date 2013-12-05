# -*- encoding : utf-8 -*-
class CouponPresenter < BasePresenter
  # include ActionView::Helpers::NumberHelper

  # def initialize coupon=nil
  #   @coupon=coupon      
  # end

  def show_total_discount   
    h.number_to_currency(coupon.action_parameter.action_params[:param]) if fixed_value_coupon?
  end

  def show_line_item_discount_for item
    unless fixed_value_coupon?
     h.link_to promotion_discount(item), "#", :class => 'discount_percent'
    end

  end

  def show_markdown?
    !fixed_value_coupon?
  end

  private
    def fixed_value_coupon?
      coupon && coupon.promotion_action.is_a?(ValueAdjustment)
    end

    def promotion_discount(item)
      percent = ( 1 - ( item.retail_price / item.price )  ) * 100.0
      percent == 100 ? "Grátis" : h.number_to_percentage(percent, :precision => 0)
    end
end