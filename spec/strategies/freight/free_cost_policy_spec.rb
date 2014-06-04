describe Freight::FreeCostPolicy do
  context "When don't match" do
    context "for inexistent shipping policy" do
      it{expect(described_class.apply?([],'59.9'.to_d)).to be_false}
    end
    context "for policy out of range" do
      before do
        @policy = FactoryGirl.build(:shipping_policy)
      end
      it{expect(described_class.apply?([@policy],'59.9'.to_d)).to be_false}
    end
  end
  context "When match" do
    before do
      @policy = FactoryGirl.build(:shipping_policy)
    end
    it{expect(described_class.apply?([@policy],'159.9'.to_d)).to be_true}
  end
end
