class AuthorizeResponse < BraspagResponse
  def self.column_names
    super | ["order_id", "braspag_order_id", "braspag_transaction_id", "amount", "payment_method"]
  end
end
