class CreditPayment < Payment
	belongs_to :credit_type

	def deliver_payment?
    self.user.user_credits_for(credit_type.code).remove({amount: total_paid, order_id: order.try(:id)})
    super
	end

  def cancel_order?
    self.user.user_credits_for(credit_type.code).add({amount: total_paid, order_id: order.try(:id)})
    super
  end
end
