# -*- encoding : utf-8 -*-
class OrderObserver < ActiveRecord::Observer
  def after_create(order)
    Resque.enqueue(Abacos::UpdateInventory)
  end
end
