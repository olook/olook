# -*- encoding : utf-8 -*-
class Payment < ActiveRecord::Base
  attr_accessor :user_name, :credit_card_number, :bank, :security_code, :expiration_date, :user_identification, :telephone, :user_birthday, :payments, :receipt
  TYPE = {:billet => 1, :debit => 2, :credit => 3}
  REASON = 'Pagamento'
  belongs_to :order
  validates_presence_of :payment_type

  def to_s
    pay_type = case payment_type
      when Payment::TYPE[:billet] then "BoletoBancario"
      when Payment::TYPE[:debit]  then "DebitoBancario"
      else "CartaoCredito"
    end
  end
end
