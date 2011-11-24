# -*- encoding : utf-8 -*-
class Billet < Payment
  validates_presence_of :receipt

  def to_s
    "BoletoBancario"
  end
end
