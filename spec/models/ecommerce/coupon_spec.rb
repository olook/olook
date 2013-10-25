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

  it { should have_many :rule_parameters }
  it { should have_many(:promotion_rules).through(:rule_parameters)}
  it { should have_one :action_parameter }
  it { should have_one(:promotion_action).through(:action_parameter)}

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

    context "coupon for n brands" do
      let(:brand_coupon) { FactoryGirl.build(:brand_coupon) }
      let(:first_product) { double(id: 1000, brand: 'Some Brand') }
      let(:other_product) { double(id: 1001, brand: 'other brand') }

      before do
        brand_coupon.stub(:brand).and_return("Some Brand,other brand")
      end

      context "first brand" do
        subject { brand_coupon.apply_discount_to? first_product }
        it { should be_true }
      end

      context "last brand" do
        subject { brand_coupon.apply_discount_to? other_product }
        it { should be_true }
      end


    end

  end

  describe "#is_more_advantageous_than_any_promotion?" do
    let(:promotion) { mock_model(Promotion)}
    let(:cart) { mock_model Cart}
    let(:coupon) { FactoryGirl.build(:coupon, value: 100) }

    before :each do
      cart.stub(:total_price).and_return(300)
    end

    context "when value is lower than sum of sale and promotion" do
      before do
        cart.should_receive(:total_promotion_discount).and_return(100)
        cart.should_receive(:total_liquidation_discount).and_return(100)
      end

      subject { coupon.is_more_advantageous_than_any_promotion?(cart) }

      it { should be_false }
    end

    context "when value is greater than sum of sale and promotion" do
      before do
        cart.should_receive(:total_promotion_discount).and_return(30)
        cart.should_receive(:total_liquidation_discount).and_return(30)
      end
      subject { coupon.is_more_advantageous_than_any_promotion?(cart) }

      it { should be_true }
    end
  end

  describe '#can_be_applied_to_any_product_in_the_cart?' do
    let(:cart) { mock_model Cart }
    let(:cart_item_invalid) { mock_model CartItem }

    before do
      mock_invalid_product = mock Product
      cart_item_invalid.stub(:product).and_return(mock_invalid_product)
    end

    subject { standard_coupon.can_be_applied_to_any_product_in_the_cart? cart }

    context "when coupon has brand" do
      before do
        standard_coupon.stub(:brand).and_return("Some Brand")
      end

      context "when cart has at least one valid item" do
        let(:cart_item_valid) { mock_model CartItem }
        before do
          mock_valid_product = mock Product
          cart_item_valid.stub(:product).and_return(mock_valid_product)

          cart.stub(:items).and_return([cart_item_invalid, cart_item_valid])

          standard_coupon.should_receive(:apply_discount_to?).with(cart_item_invalid.product).and_return(false)
          standard_coupon.should_receive(:apply_discount_to?).with(cart_item_valid.product).and_return(true)
        end
        it { should be_true }
      end

      context "when product has no valid items" do
        let(:another_cart_item_invalid) { mock_model CartItem }

        before do
          another_mock_invalid_product = mock Product
          another_cart_item_invalid.stub(:product).and_return(another_mock_invalid_product)

          cart.stub(:items).and_return([cart_item_invalid, another_cart_item_invalid])

          standard_coupon.should_receive(:apply_discount_to?).with(cart_item_invalid.product).and_return(false)
          standard_coupon.should_receive(:apply_discount_to?).with(another_cart_item_invalid.product).and_return(false)
        end
        it { should be_false }
      end
    end

    context "when coupon has no brand" do
      before do
        standard_coupon.stub(:brand).and_return(nil)
      end
      it { should be_true }
    end
  end
end
