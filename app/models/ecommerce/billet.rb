# -*- encoding : utf-8 -*-
class Billet < Payment

  EXPIRATION_IN_DAYS = 3
  validates :receipt, :presence => true, :on => :create
  after_create :set_payment_expiration_date

  state_machine :initial => :started do
    after_transition :billet_printed => :authorized, :do => :authorize_order
    after_transition :authorized => :under_review, :do => :review_order
    after_transition :under_review => :refunded, :do => :refund_order
    after_transition :started => :canceled, :do => :cancel_order
    after_transition :billet_printed => :canceled, :do => :cancel_order

    event :billet_printed do
      transition :started => :billet_printed
    end

    event :authorized do
      transition :billet_printed => :authorized
    end

    event :canceled do
      transition :started => :canceled, :billet_printed => :canceled
    end

    event :completed do
      transition :authorized => :completed, :under_review => :completed
    end

    event :under_review do
      transition :authorized => :under_review
    end

    event :refunded do
      transition :under_review => :refunded
    end
  end

  def to_s
    "BoletoBancario"
  end

  def human_to_s
    "Boleto Bancário"
  end

  def build_payment_expiration_date
    EXPIRATION_IN_DAYS.days.from_now
  end
end
