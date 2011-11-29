# -*- encoding : utf-8 -*-
class Billet < Payment

  state_machine :initial => :started do
    after_transition :authorized => :completed, :do => :complete_order
    after_transition :under_review => :completed, :do => :complete_order
    after_transition :authorized => :under_review, :do => :review_order
    after_transition :under_review => :refunded, :do => :refund_order

    event :billet_printed do
      transition :started => :billet_printed
    end

    event :authorized do
      transition :billet_printed => :authorized
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
