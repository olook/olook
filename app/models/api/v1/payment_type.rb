class Api::V1::PaymentType
  def self.all
    [CreditCard, Debit, Billet, MercadoPagoPayment].map { |p| p.api_hash }
  end

  def self.find(type)
    all.find { |p| p[:type].to_s == type.to_s }
  end
end

