class ClearsaleOrderResponse < ActiveRecord::Base
  belongs_to :order
  attr_accessor :order_id, :status, :score

  STATES_TO_BE_PROCESSED = [
    :manual_analysis,
    :waiting
  ]

  def self.to_be_processed
    where("processed = false AND status IN (#{STATES_TO_BE_PROCESSED.map{|state| "\'"+state.to_s+"\'"}.join(',')})")
  end
end
