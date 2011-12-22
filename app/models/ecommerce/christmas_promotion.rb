# -*- encoding : utf-8 -*-
class ChristmasPromotion
  attr_accessor :user, :order

  START_AT = DateTime.civil(2011, 12, 22, 15, 47, 0, Rational(-2, 24))
  END_AT   = DateTime.civil(2011, 12, 26, 23, 59, 0, Rational(-2, 24))

  def initialize(order, user = nil)
    @order, @user = order, user
  end

  def order_line_items
    if self.is_active?
      order.line_items_with_flagged_gift
    else
      order.clear_gift_in_line_items
      order.line_items
    end
  end

  def is_active?
    (END_AT > DateTime.now) && (DateTime.now > START_AT)
  end
end
