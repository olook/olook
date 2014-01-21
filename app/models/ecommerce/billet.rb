# -*- encoding : utf-8 -*-
class Billet < Payment

  scope :expire_at, ->(date_for_search) {where(payment_expiration_date: date_for_search.beginning_of_day..date_for_search.end_of_day, state: ["waiting_payment", "started"]).order("total_paid DESC")}

  EXPIRATION_IN_DAYS = 3
  validates :receipt, :presence => true, :on => :create
  before_create :set_payment_expiration_date

  def payments=(val)
    write_attribute(:payments, "1" )
  end

  def to_s
    "BoletoBancario"
  end

  def human_to_s
    "Boleto Bancário"
  end

  def expired_and_waiting_payment?
    self.expired? && self.order.waiting_payment?
  end

  def expired?
    Date.current > BilletExpirationDate.expiration_for_two_business_day(self.payment_expiration_date.to_date) if self.payment_expiration_date
  end

  def schedule_cancellation
    #TODO: double check whether to plug the 4 biz days rule into BilletExpirationDate
    Resque.enqueue_at(5.business_days.from_now.beginning_of_day, Abacos::CancelOrder, self.order.number)
  end

  def self.to_expire
    expiration_date = 1.business_day.before(Time.zone.now) - 1.day
    self.where(payment_expiration_date: expiration_date.beginning_of_day..expiration_date.end_of_day, state: ["waiting_payment", "started"])
  end

  private

    def build_payment_expiration_date
      BilletExpirationDate.expiration_for_two_business_day
    end
end
