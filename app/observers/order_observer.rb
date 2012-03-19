# -*- encoding : utf-8 -*-
class OrderObserver < ActiveRecord::Observer
  def after_create(order)
    Resque.enqueue(Abacos::UpdateInventory)
  end

  def before_destroy(order)
    if order.credits > 0
      Credit.add(order.credits, order.user, order)
    end
  end
end
