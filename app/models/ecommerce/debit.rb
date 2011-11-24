# -*- encoding : utf-8 -*-
class Debit < Payment
  attr_accessor :bank
  def to_s
    "DebitoBancario"
  end
end
