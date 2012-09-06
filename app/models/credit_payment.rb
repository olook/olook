class CreditPayment < Payment
	belongs_to :credit_type
  validates :credit_type_id, :presence => true

	def deliver_payment?
    credits = self.user.user_credits_for(credit_type.code).remove({value: total_paid, order_id: order.try(:id)})
    if credits
      self.update_column(:credit_ids, credits.map{|credit| credit.id.to_s}.join(','))
      super
    end
	end

  def cancel_order?
    delete_credits
    super
  end

  def reverse_order?
    delete_credits
    super
  end

  def refund_order?
    delete_credits
    super
  end

  private
    def delete_credits
      # super if self.user.user_credits_for(credit_type.code).add({amount: total_paid, order_id: order.try(:id)})    
      self.credit_ids.split(',').each do |credit_id|
        Credit.find(credit_id).try(:delete)
      end
      self.update_column(:credit_ids, '')
    end
end
