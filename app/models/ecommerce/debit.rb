# -*- encoding : utf-8 -*-
class Debit < Payment
  attr_accessor :bank, :receipt
  def to_s
    "DebitoBancario"
  end
end
