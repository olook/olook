describe ProductSearch do
  describe ".terms_for" do
    let!(:product) { FactoryGirl.create(:basic_shoe) }
    context "when has terms for given parameter" do
      let!(:another_product) { FactoryGirl.create(:basic_shoe, name: "Scarpin") }
      it "returns only names like 'Chan'" do
        expect(described_class.terms_for("Chan")).to include(product.name)
        expect(described_class.terms_for("Chan")).to_not include(another_product.name)
      end
    end

    context "when there's no terms for given parameter" do
      it "returns an empty array" do
        expect(described_class.terms_for("Something")).to eq([])
      end
    end
  end
end
