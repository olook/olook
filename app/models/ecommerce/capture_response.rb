class CaptureResponse < BraspagResponse
  attr_accessor :braspag_transaction_id, :acquirer_transaction_id, :amount, :authorization_code, :return_code, :return_message, :transaction_status
end
