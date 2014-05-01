class CreditCardDetectorService

  def self.detect credit_card_number
    return "Visa" if credit_card_number =~ /^4/
    return "Mastercard" if credit_card_number =~ /^5[1-5]/
    return "Diners" if credit_card_number =~ /^3(?:0[0-5]|[68][0-9])/
  end
end
