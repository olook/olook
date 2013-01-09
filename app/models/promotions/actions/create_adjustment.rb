# -*- encoding : utf-8 -*-
class CreateAdjustment < PromotionAction
  include Parameters

  parameter :percent, :integer

  def apply(cart, promotion)
    cart.items.each do |cart_item|
      sub_total = cart_item.quantity * cart_item.price
      adjust = sub_total * BigDecimal("#{percent / 100.0}")
      cart_item.adjustment.update_attribute(:value, adjust)
    end
  end


  def params
    # TODO improve this
    action_parameters.first.param
  end

  def params= value
    # TODO improve this
    action_parameters.first.param = value
  end

end
