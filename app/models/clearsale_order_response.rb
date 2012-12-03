class ClearsaleOrderResponse < ActiveRecord::Base
  belongs_to :order

  PENDING_STATUS = [
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
    where(:processed => false)
  end

  def has_pending_status?
    ClearsaleOrderResponse::PENDING_STATUS.include?(self.status.to_sym)
  end

  def has_an_accepted_status?
    ClearsaleOrderResponse::AUTHORIZED_STATUS.include?(self.status.to_sym)
  end

  def has_a_rejected_status?
    ClearsaleOrderResponse::REJECTED_STATUS.include?(self.status.to_sym)
  end  


end
