describe Api::PaymentTypes do

  it "returns hash with payment info" do
    expect(described_class.types).to include("types")
  end
  context "types key" do
    it "return credit card info" do
      expect(described_class.types["types"]).to include("credit_card")
    end
    it "return debit info" do
      expect(described_class.types["types"]).to include("debit")
    end
    it "return billet info" do
      expect(described_class.types["types"]).to include("billet")
    end
    it "return mercado pago info" do
      expect(described_class.types["types"]).to include("mercado_pago")
    end
  end
  context "payment keys" do
    it "specific payment value" do
      described_class.types["types"].values.each do |value|
        expect(value.keys).to include("name", "percentage", "description")
      end
    end
  end
end
