# -*- encoding : utf-8 -*-
class Orders::SurveyEmailWorker
  @queue = :low

  def self.perform(order_id)
    order = Order.find(order_id)
    SurveyMailer.order_survey(order).deliver
  end
end

