class ClearsaleOrderResponse < ActiveRecord::Base
  belongs_to :order

  STATES_TO_BE_PROCESSED = [
    :manual_analysis,
    :waiting
  ]

  AUTHORIZED_STATUS = [
    :automatic_approval,
    :manual_approval
  ]

  REJECTED_STATUS = [
    :rejected_without_suspicion,
    :error,
    :manual_rejection,
    :cancelled,
    :fraud
  ]

  def self.to_be_processed
    where("processed = false AND status IN (#{STATES_TO_BE_PROCESSED.map{|state| "\'"+state.to_s+"\'"}.join(',')})")
  end
end
