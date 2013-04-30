# -*- encoding: utf-8 -*-
ActiveSupport::Notifications.subscribe "summarize.sell" do |name, start, finish, id, payload|
  order = payload[:order]
  order.line_items do |line_item|
    ConsolidatedSell.summarize line_item.variant, line_item.quantity
  end
end