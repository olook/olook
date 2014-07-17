# -*- encoding : utf-8 -*-
class B2bPayment < Payment

  validates :receipt, :presence => true, :on => :create
  before_create :set_payment_expiration_date

  def payments=(val)
    write_attribute(:payments, "1" )
  end

  def to_s
    "Venda Atacado"
  end

  def human_to_s
    "Liberacao Manual"
  end

  def expired_and_waiting_payment?
    self.expired? && self.order.waiting_payment?
  end

  def expired?
    false
  end

  private

    def build_payment_expiration_date
      Time.zone.now + 6.months
    end
end
