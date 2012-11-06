class AuthorizeResponse < BraspagResponse
  scope :to_process, where(:processed => false).order(:id)
  
  def self.column_names
    super | ["order_id", "braspag_order_id", "braspag_transaction_id", "amount", "payment_method", "acquirer_transaction_id", 
             "authorization_code", "return_code", "return_message", "transaction_status", "credit_card_token"]
  end

  def update_payment_status(payment)
    
  end
  
end
