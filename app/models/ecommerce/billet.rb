# -*- encoding : utf-8 -*-
class Billet < Payment

  STATUS = {
    "1" => :authorized,
    "2" => :started,
    "3" => :billet_printed,
    "4" => :completed,
    "5" => :canceled,
    "6" => :under_review
  }

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

  def set_state(status)
    send(STATUS[status])
  end

  def to_s
    "BoletoBancario"
  end
end
