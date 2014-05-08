describe Shipping::Policy do
  before do
    @default_zip_code = "05302030"
    @default_amount = "89.9"
  end
  context "#free_shipping?" do
    context "when it doesn`t receive the params" do
      it{expect(subject.free_shipping?).to be_false}
    end
    context "when it doesn`t find a policy" do
      it{ expect(described_class.new(@default_zip_code, @default_amount).free_shipping?).to be_false}
    end
    context "When a policy is found" do
      context "but the amount is less than minimum for free shipping" do
        before do
          @policy = described_class.new(@default_zip_code, @default_amount)
          @policy.should_receive(:has_free_shipping?).and_return(false)
        end
        it{  expect(@policy.free_shipping?).to be_false }
      end
      context "for a given zip_code" do
        before do
          @policy = described_class.new(@default_zip_code, @default_amount)
          @policy.should_receive(:has_free_shipping?).and_return(true)
        end
        it{ expect(@policy.free_shipping?).to be_true }
      end
    end
  end
end
