class CreditPayment < Payment
	belongs_to :credit_type
  validates :credit_type_id, :presence => true

	def deliver_payment?
    super if self.user.user_credits_for(credit_type.code).remove({amount: total_paid, order_id: order.try(:id)})
	end

  def cancel_order?
    super if self.user.user_credits_for(credit_type.code).add({amount: total_paid, order_id: order.try(:id)})    
  end
end
