require 'spec_helper.rb'

describe Api::V1::PaymentType do

  context "type keys" do
    it "return credit card info" do
      expect(described_class.all.map{|a| a[:type]}).to include("CreditCard")
    end
    it "return debit info" do
      expect(described_class.all.map{|a| a[:type]}).to include("Debit")
    end
    it "return billet info" do
      expect(described_class.all.map{|a| a[:type]}).to include("Billet")
    end
    it "return mercado pago info" do
      expect(described_class.all.map{|a| a[:type]}).to include("MercadoPagoPayment")
    end
  end
  context "payment keys" do
    it "specific payment value" do
      described_class.all.each do |value|
        expect(value.keys).to include(:name, :percentage, :type)
      end
    end
  end
end
