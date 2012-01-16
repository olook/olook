# -*- encoding : utf-8 -*-
class Debit < Payment
  attr_accessor :receipt

  BANKS_OPTIONS = ["BancoDoBrasil", "Bradesco", "Itau", "Banrisul"]
  EXPIRATION_IN_MINUTES = 60

  validates :bank, :receipt, :presence => true, :on => :create
  after_create :set_payment_expiration_date

  state_machine :initial => :started do
    after_transition :started => :canceled, :do => :cancel_order
    after_transition :started => :authorized, :do => :authorize_order
    after_transition :authorized => :under_review, :do => :review_order
    after_transition :under_review => :refunded, :do => :refund_order

    event :canceled do
      transition :started => :canceled
    end

    event :authorized do
      transition :started => :authorized
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
    "DebitoBancario"
  end

  def human_to_s
    "Débito Bancário"
  end

  def build_payment_expiration_date
    EXPIRATION_IN_MINUTES.minutes.from_now
  end

  def expired_and_waiting_payment?
    (self.expired? && self.order.state == "waiting_payment") ? true : false
  end

  def expired?
    Time.now > self.payment_expiration_date if self.payment_expiration_date
  end
end
