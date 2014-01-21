describe FullLook::LookProfileCalculator do
  before do
    @product1 = FactoryGirl.build(:shoe)
    @product2 = FactoryGirl.build(:bag)
    @product3 = FactoryGirl.build(:basic_accessory)
    @product4 = FactoryGirl.build(:simple_garment)
  end
  context "when products have on profile" do
    before do
      @profile = mock("sexy", name: "sexy")
      @product1.should_receive(:profiles).and_return([@profile])
      @product2.should_receive(:profiles).and_return([@profile])
      @product3.should_receive(:profiles).and_return([@profile])
      @product4.should_receive(:profiles).and_return([@profile])
    end
    context "have more sexy" do
      it "be sexy" do
        expect(described_class.calculate([@product1,@product2,@product3,@product4])).to eql "sexy"
      end
    end
  end
end

