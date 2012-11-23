class ClearsaleOrderResponse < ActiveRecord::Base
  belongs_to :order
  attr_accessor :order_id, :status, :score

  STATES_TO_BE_PROCESSED = [
    :manual_analysis,
    :waiting
  ]

  def initialize(order_id, status, score)
    self.order_id = order_id
    self.status = status
    self.score = score
  end

  def self.to_be_processed
    where("processed = false AND status IN (#{STATES_TO_BE_PROCESSED.map{|state| "\'"+state.to_s+"\'"}.join(',')})")
  end
end
