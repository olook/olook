# -*- encoding : utf-8 -*-
class Promotion
  attr_accessor :user, :order

  def initialize(user, order)
    @user, @order = user, order
  end

  def line_items_for_christmas_promotion
    order.line_items_with_flagged_gift
  end
end
