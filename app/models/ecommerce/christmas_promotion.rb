# -*- encoding : utf-8 -*-
class ChristmasPromotion
  attr_accessor :user, :order

  START_AT = DateTime.civil(2011, 12, 22, 12, 12, 0, Rational(-2, 24))
  END_AT   = DateTime.civil(2011, 12, 25, 12, 12, 0, Rational(-2, 24))

  def initialize(order, user = nil)
    @order, @user = order, user
  end

  def order_line_items
    line_items = (self.is_active?) ? order.line_items_with_flagged_gift : order.line_items
  end

  def is_active?
    (END_AT > DateTime.now) && (DateTime.now > START_AT)
  end
end
