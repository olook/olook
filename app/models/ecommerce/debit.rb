# -*- encoding : utf-8 -*-
class Debit < Payment
  attr_accessor :bank, :user_identification
  validates_presence_of :bank, :receipt
  def to_s
    "DebitoBancario"
  end
end
