class CouponPresenter
  include ActionView::Helpers::NumberHelper

  def initialize coupon=nil
    @coupon=coupon      
  end

  def show_total_discount
    if @coupon && @coupon.action_parameter.action_params
      number_to_currency(@coupon.action_parameter.action_params[:param]).html_safe
    end
  end

  def show_line_item_discount_for item
  end

  def show_markdown?
    false
  end

end