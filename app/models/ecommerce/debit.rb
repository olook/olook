# -*- encoding : utf-8 -*-
class Debit < Payment
  attr_accessor :bank, :user_identification
  validates_presence_of :bank, :receipt

  state_machine :initial => :aberta do
    #after_transition  :aberta => :concluida, :do => :notificar_por_email
    #before_transition :concluida => :disputada, :do => :registrar_log

    event :done do
      transition :aberta => :done
    end

    event :cancel do
      transition :aberta => :cancel, :done => :cancel
    end
  end

  def to_s
    "DebitoBancario"
  end
end
