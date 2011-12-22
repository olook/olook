# -*- encoding: utf-8 -*-
class PaymentManager
  attr_accessor :billet, :credit_card, :debit

  def initialize
    @billet, @credit_card, @debit = "Billet", "CreditCard", "Debit"
  end

  def expires_billet
    search_and_cancel(@billet)
  end

  def expires_credit_card
    search_and_cancel(@credit_card)
  end

  def expires_debit
    search_and_cancel(@debit)
  end

  private

  def search_and_cancel(payment_type)
    Payment.where(:type => payment_type).find_each do |payment|
      # Later we need to include #canceled event to billet
      # payments to avoid workarounds. -zanst
      if payment.type == @billet
        payment.order.canceled if payment.expired_and_waiting_payment_or_started?
      else
        payment.canceled if payment.expired_and_waiting_payment_or_started?
      end
    end
  end
end

