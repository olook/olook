# -*- encoding : utf-8 -*-
class Debit < Payment
  attr_accessor :receipt

  #TODO All the other banks except Itau, were disabled.
  #BANKS_OPTIONS = ["BancoDoBrasil", "Bradesco", "Itau", "Banrisul"]

  BANKS_OPTIONS = ["Itau"]
  EXPIRATION_IN_MINUTES = 60

  validates :bank, :receipt, :presence => true, :on => :create
  before_create :set_payment_expiration_date

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
    (self.expired? && self.order.waiting_payment?) ? true : false
  end

  def expired?
    Time.now > self.payment_expiration_date if self.payment_expiration_date
  end

  def schedule_cancellation
    #TODO: this is independent of the rest of the expiration settings and calculations
    Resque.enqueue_at(5.business_hour.from_now, Abacos::CancelOrder, self.order.number)
  end
end
