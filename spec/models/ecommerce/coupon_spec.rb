require 'spec_helper'

describe Coupon do
  let(:standard_coupon) { FactoryGirl.create(:standard_coupon) }
  let(:expired_coupon) { FactoryGirl.create(:expired_coupon) }
  let(:unlimited_coupon) { FactoryGirl.create(:unlimited_coupon) }
  let(:limited_coupon) { FactoryGirl.create(:limited_coupon) }
  subject { FactoryGirl.create(:standard_coupon, value: 100) }

  before :each do
    Coupon.destroy_all
    Timecop.return
  end

  context 'validations' do
    it {should validate_presence_of(:code)}
    it {should validate_presence_of(:value)}
    it {should validate_presence_of(:start_date)}
    it {should validate_presence_of(:end_date)}
    it {should validate_presence_of(:campaign)}
    it {should validate_presence_of(:created_by)}
    it {should validate_presence_of(:remaining_amount)}

    it "should be invalid if coupon if limited and dont have a remaining_amount" do
      coupon = FactoryGirl.build(:standard_coupon)
      coupon.remaining_amount = ''
      coupon.should_not be_valid
    end
  end

  describe "#initialize" do
    context "by default" do
      it "set 1 on modal" do
        expect(standard_coupon.modal).to eql(1)
      end
    end
    context "using modal with nil" do
      let!(:standard_coupon) { FactoryGirl.create(:standard_coupon, modal: nil) }
      it "set 1 on modal" do
        expect(standard_coupon.modal).to eql(1)
      end
    end
  end

  context 'methods' do
    it 'should be true if coupon is available' do
      standard_coupon.available?.should be_true
    end

    it 'should be false if coupon is not available' do
      expired_coupon.available?.should be_false
    end

    it 'should be true if coupon is expired' do
      expired_coupon.expired?.should be_true
    end

    it 'should be false if coupon is not expired' do
      standard_coupon.expired?.should be_false
    end
  end

  context 'callbacks' do
    it 'should set unlimited as true when remaining_amount is nil' do
      unlimited_coupon.unlimited.should be_true
    end

    it 'should set unlimited as false when remaining_amount is 1 or more' do
      limited_coupon.unlimited.should be_false
    end
  end

  context "#apply_discount_to?" do
    context "when coupon is product specific" do
      let(:product_coupon) { FactoryGirl.create(:product_coupon) }

      it "returns true for product 9640" do
        product = double(id: 9640, brand: nil)
        product_coupon.apply_discount_to?(product).should be_true
      end

      it "returns false for product 9641" do
        product = double(id: 9641, brand: '')
        product_coupon.apply_discount_to?(product).should be_false
      end

      it "returns false for product 9641" do
        product = double(id: 9641, brand: nil)
        product_coupon.apply_discount_to?(product).should be_false
      end

      context "and product has a brand" do
        before do
          @product = double(id: 9640, brand: 'Olook')
        end
        it { expect(product_coupon.apply_discount_to?(@product)).to be_true }
      end
    end

    context "coupon for an specific brand" do
      let(:brand_coupon) { FactoryGirl.create(:brand_coupon) }

      context "when product is not from configured brand" do
        let(:product) { double(id: 1000, brand: 'Olook Concept') }
        it "returns false" do
          brand_coupon.apply_discount_to?(product).should be_false
        end
      end

      context "when product is from configured brand" do
        let(:product) { double(id: 1000, brand: 'Olook') }
        it "returns true" do
          brand_coupon.apply_discount_to?(product).should be_true
        end
      end

    end

  end

  describe "#should_apply_to?" do
    let(:promotion) { mock_model(Promotion)}
    let(:cart) { mock_model Cart}

    before :each do
      cart.stub(:total_price).and_return(300)
    end

    context "when value is lower than sum of sale and promotion" do
      it "returns false" do
        cart.should_receive(:total_promotion_discount).and_return(100)
        cart.should_receive(:total_liquidation_discount).and_return(100)
        subject.should_receive(:value).and_return(100)
        subject.should_apply_to?(cart).should be_false
      end
    end

    context "when value is greater than sum of sale and promotion" do
      it "returns true" do
        cart.should_receive(:total_promotion_discount).and_return(30)
        cart.should_receive(:total_liquidation_discount).and_return(30)
        subject.should_receive(:value).and_return(100)
        subject.should_apply_to?(cart).should be_true
      end
    end
  end
end
