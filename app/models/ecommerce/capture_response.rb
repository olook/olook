class CaptureResponse < BraspagResponse
  def self.column_names
    super | ["braspag_transaction_id", "acquirer_transaction_id", "amount", "authorization_code", "return_code", "return_message", "transaction_status"] 
  end
end
