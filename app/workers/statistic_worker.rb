# -*- encoding : utf-8 -*-
class StatisticWorker
  @queue = :statistics

  def self.perform(order_id)
    order = Order.find order_id
    order.line_items.each do |line_item|
      ConsolidatedSell.summarize order.created_at, line_item.variant.product, line_item.quantity
    end
  end

end
