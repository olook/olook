class AuthorizeResponse < BraspagResponse
  attr_accessor :order_id, :braspag_order_id, :braspag_transaction_id, :amount, :payment_method
end
