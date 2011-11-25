# -*- encoding : utf-8 -*-
class Debit < Payment
  attr_accessor :bank, :user_identification
  validates_presence_of :bank, :receipt

  state_machine :initial => :started do
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
    "DebitoBancario"
  end
end
