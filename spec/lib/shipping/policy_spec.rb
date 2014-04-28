describe Shipping::Policy, focus: true do
  before do
    @default_zip_code = "05302030"
    @default_amount = "89.9"
  end
  context "#free_shipping?" do
    context "when dont receive params" do
      it "return false" do
        expect(subject.free_shipping?).to be_false
      end
    end
    context "when dont find model" do
      it "return false" do
        expect(described_class.new(@default_zip_code, @default_amount).free_shipping?).to be_false
      end
    end
    context "When found policy for cep" do
      before do
        @policy = described_class.new(@default_zip_code, @default_amount)
        @policy.should_receive(:seek_policy).and_return([mock(:shipping_policy)])
      end
      it "return true" do
        expect(@policy.free_shipping?).to be_true
      end
    end
  end
end
