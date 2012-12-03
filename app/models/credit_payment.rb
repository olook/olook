# == Schema Information
#
# Table name: payments
#
#  id                         :integer          not null, primary key
#  order_id                   :integer
#  url                        :text
#  created_at                 :datetime
#  updated_at                 :datetime
#  type                       :string(255)
#  state                      :string(255)
#  user_name                  :string(255)
#  credit_card_number         :string(255)
#  bank                       :string(255)
#  expiration_date            :string(255)
#  telephone                  :string(255)
#  user_birthday              :string(255)
#  payments                   :integer
#  gateway_status             :integer
#  gateway_code               :string(255)
#  gateway_type               :string(255)
#  payment_expiration_date    :datetime
#  reminder_sent              :boolean          default(FALSE)
#  gateway_status_reason      :string(255)
#  identification_code        :string(255)
#  cart_id                    :integer
#  credit_type_id             :integer
#  credit_ids                 :text
#  coupon_id                  :integer
#  total_paid                 :decimal(8, 2)
#  promotion_id               :integer
#  discount_percent           :integer
#  percent                    :decimal(8, 2)
#  gateway_response_id        :string(255)
#  gateway_response_status    :string(255)
#  gateway_token              :text
#  gateway_fee                :decimal(8, 2)
#  gateway_origin_code        :string(255)
#  gateway_transaction_status :string(255)
#  gateway_message            :string(255)
#  gateway_transaction_code   :string(255)
#  gateway_return_code        :integer
#  user_id                    :integer
#  gateway                    :integer
#  security_code              :string(255)
#

class CreditPayment < Payment
	belongs_to :credit_type
  validates :credit_type_id, :presence => true

	def deliver_payment?
    credits = self.user.user_credits_for(credit_type.code).remove({amount: total_paid, order_id: order.try(:id)})
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
    if self.credit_ids
      self.credit_ids.split(',').each do |credit_id|
        Credit.find(credit_id).try(:delete)
      end
      self.update_column(:credit_ids, '')
    end
  end
end
