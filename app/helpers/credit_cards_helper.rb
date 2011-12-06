# -*- encoding : utf-8 -*-
module CreditCardsHelper
  def payment_options(total, payments)
    options = []
    1.upto(payments) do |i|
      options << ["#{i}x de #{number_to_currency(total / i)} sem juros", i]
    end
    options
  end
end

