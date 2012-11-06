class CaptureResponse < BraspagResponse
  scope :to_process, where(:processed => false).order(:id)
  
  def self.column_names
    super | ["braspag_transaction_id", "acquirer_transaction_id", "amount", "authorization_code", "return_code", "return_message", "transaction_status"] 
  end

  def update_payment_status(payment)
    
  end
  
end
