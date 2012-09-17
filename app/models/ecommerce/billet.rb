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
