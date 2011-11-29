# -*- encoding : utf-8 -*-
class Debit < Payment
  attr_accessor :bank, :user_identification
  validates_presence_of :bank, :receipt

  BANKS_OPTIONS = ["BancoDoBrasil", "Bradesco", "Itau", "BancoReal", "Unibanco", "Banrisul"]

  state_machine :initial => :started do
    after_transition :started => :canceled, :do => :cancel_order
    after_transition :authorized => :completed, :do => :complete_order
    after_transition :under_review => :completed, :do => :complete_order
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

  private

  def refund_order
    order.refunded
  end

  def review_order
    order.under_review
  end

  def cancel_order
    order.canceled
  end

  def complete_order
    order.completed
  end
end
