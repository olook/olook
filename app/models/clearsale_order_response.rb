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
    where(:processed => false, :status => ClearsaleOrderResponse::STATES_TO_BE_PROCESSED.map{|s| s.to_s})
  end

  def has_to_be_processed?
    ClearsaleOrderResponse::STATES_TO_BE_PROCESSED.include?(self.status.to_sym)
  end

  def has_an_accepted_status?
    ClearsaleOrderResponse::AUTHORIZED_STATUS.include?(self.status.to_sym)
  end

  def has_a_rejected_status?
    ClearsaleOrderResponse::REJECTED_STATUS.include?(self.status.to_sym)
  end  


end
