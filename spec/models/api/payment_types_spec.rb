require 'spec_helper.rb'

describe Api::PaymentTypes do

  context "type keys" do
    it "return credit card info" do
      expect(described_class.types.map{|a| a["type"]}).to include("CreditCard")
    end
    it "return debit info" do
      expect(described_class.types.map{|a| a["type"]}).to include("Debit")
    end
    it "return billet info" do
      expect(described_class.types.map{|a| a["type"]}).to include("Billet")
    end
    it "return mercado pago info" do
      expect(described_class.types.map{|a| a["type"]}).to include("MercadoPago")
    end
  end
  context "payment keys" do
    it "specific payment value" do
      described_class.types.each do |value|
        expect(value.keys).to include("name", "percentage", "description", "type")
      end
    end
  end
end
