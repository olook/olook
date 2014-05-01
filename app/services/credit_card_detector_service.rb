class CreditCardDetectorService

  def self.detect credit_card_number
    return "Visa" if credit_card_number =~ /^4/
    return "Mastercard" if credit_card_number =~ /^5[1-5]/
    return "Amex" if credit_card_number =~ /^3[47]/
  end
end
