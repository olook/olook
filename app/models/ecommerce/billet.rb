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

# -*- encoding : utf-8 -*-
class Billet < Payment

  EXPIRATION_IN_DAYS = 3
  validates :receipt, :presence => true, :on => :create
  after_create :set_payment_expiration_date

  def to_s
    "BoletoBancario"
  end

  def human_to_s
    "Boleto Bancário"
  end

  def expired_and_waiting_payment?
    (self.expired? && self.order.waiting_payment?) ? true : false
  end

  def expired?
    Date.current > BilletExpirationDate.expiration_for_two_business_day(self.payment_expiration_date.to_date) if self.payment_expiration_date
  end

  private
  def build_payment_expiration_date
    BilletExpirationDate.expiration_for_two_business_day
  end
end
