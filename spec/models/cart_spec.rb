require 'spec_helper'

describe Cart do
  it { should belong_to(:user) }
  it { should have_many(:orders) }
  it { should have_many(:items) }

  let(:basic_shoe) { FactoryGirl.create(:shoe, :casual) }
  let(:basic_shoe_35) { FactoryGirl.create(:basic_shoe_size_35, :product => basic_shoe) }
  let(:basic_shoe_37) { FactoryGirl.create(:basic_shoe_size_37, :product => basic_shoe) }

  let(:cart) { FactoryGirl.create(:clean_cart) }
  let(:cart_with_one_item) { FactoryGirl.create(:cart_with_one_item) }
  let(:cart_with_items) { FactoryGirl.create(:cart_with_items) }
  let(:cart_with_gift) { FactoryGirl.create(:cart_with_gift) }

  describe "#facebook_share_discount?" do
    it { should respond_to :facebook_share_discount? }
    it { should respond_to(:facebook_share_discount=).with(1).arguments }

    context "when set to true" do
      before do
        cart.facebook_share_discount = true
      end

      it { cart.facebook_share_discount?.should be_true }
    end

    context "when set to false" do
      before do
        cart.facebook_share_discount = false
      end

      it { cart.facebook_share_discount?.should be_false }
    end

  end

  describe "#sub_total" do
    context "when cart is empty" do

      it "returns 0" do
        cart.sub_total.should == 0
      end
    end

    context "when cart has one item (price = 60, retail_price = 60, quantity = 1)" do

      before do
        @cart_item = cart_with_one_item.items.first
        @cart_item.stub(:quantity => 1)
        @cart_item.stub(:price => BigDecimal("60"))
        @cart_item.stub(:retail_price).and_return(BigDecimal("60"))
      end

      it "returns 60" do
        cart_with_one_item.sub_total.should == 60
      end

    end
  end

  describe "#total_liquidation_discount" do
    context "when cart has no items" do
      it "returns 0" do
        cart.total_liquidation_discount.should == 0
      end
    end


    context "when cart has 1 item (price = 10)" do
      let(:first_item) {cart_with_one_item.items.first}

      before do
        first_item.stub(:price => BigDecimal("10"))
        first_item.stub(:retail_price => BigDecimal("10"))
      end

      context "and it is NOT in a liquidation" do
        it "returns 0" do
          cart_with_one_item.total_liquidation_discount.should == 0
        end
      end

      context "and it IS IN a 30% liquidation" do
        before do
          first_item.stub(:retail_price => BigDecimal("7"))
        end

        it "returns 3" do
          cart_with_one_item.total_liquidation_discount.should == 3
        end
      end
    end

    context "when cart has 2 items (item1.price = 100, item2.price = 80)" do
      let(:cart_2_items) {cart_with_one_item}
      let(:first_item) {cart_2_items.items.first}
      let(:second_item) {FactoryGirl.create(:cart_item_2, :cart => cart_2_items)}

      before do
        cart_2_items.items << second_item
        first_item.stub(:price => 100)
        second_item.stub(:price => 80)
        second_item.stub(:quantity => 1)
      end

      context "and one is in a 30% liquidation and the another has 20% promotion" do
        before do
          first_item.stub(:retail_price => 70)
          second_item.stub(:adjustment_value => 16)
        end

        it "returns 30" do
          cart_2_items.total_liquidation_discount.should == 30
        end
      end
    end

  end

  describe "#total_promotion_discount" do

    context "when cart has no items" do
      it "returns 0" do
        cart.total_promotion_discount.should == 0
      end
    end

    context "when cart has 1 item with adjustment_value = 10" do
      let(:first_item) {cart_with_one_item.items.first}

      before do
        adjustment = mock('adjustment')
        adjustment.stub(:source => 'Promotion: Megaboga promotion')
        adjustment.stub(:update_attributes => nil)
        first_item.stub(:cart_item_adjustment => adjustment)
        first_item.stub(:adjustment_value => BigDecimal("10"))
      end

      it "returns 10" do
        cart_with_one_item.total_promotion_discount.should == 10
      end

      context "when cart has a second item with adjustment_value = 40" do
        let(:second_item) {FactoryGirl.create(:cart_item_2, :cart => @cart)}

        before do
          @cart = cart_with_one_item
          @cart.items << second_item

          adjustment = mock('second adjustment')
          adjustment.stub(:update_attributes => nil)
          adjustment.stub(:source => 'Promotion: Megaboga promotion')
          second_item.stub(:cart_item_adjustment => adjustment)
          second_item.stub(:adjustment_value => BigDecimal("40"))
        end

        it "returns 50" do
          @cart.total_promotion_discount.should == 50
        end

        context "and second item has quantity = 5 " do
          before do
            second_item.stub(:quantity => 5)
          end

          it "returns 50" do
            @cart.total_promotion_discount.should == 50
          end
        end
      end

    end
  end

  describe "#allow_credit_payment?" do
    before do
      cart_with_one_item.stub(:sub_total).and_return(BigDecimal("110,00"))
    end

    context "when cart has one item with full price" do
      it { expect(cart_with_one_item.allow_credit_payment?).to be_true }
    end

    context "when cart has no items with full price" do
      it { expect(cart.allow_credit_payment?).to be_false }
    end

    context "when some item of cart has adjustment" do
      before do
        cart_with_one_item.items.first.stub(:has_adjustment?).and_return(true)
      end
      it { expect(cart_with_one_item.allow_credit_payment?).to be_false }
    end

    context "when all items of cart has no adjustment" do
      before do
        cart_with_one_item.items.first.stub(:has_adjustment?).and_return(false)
      end
      it { expect(cart_with_one_item.allow_credit_payment?).to be_true }
    end

    context "when cart#subtotal is greater than R$ 100" do
      it "returns true" do
        expect(cart_with_one_item.allow_credit_payment?).to be_true
      end
    end

    context "when cart#subtotal is equals R$ 100" do
      it "returns true" do
        cart_with_one_item.stub(:sub_total).and_return(BigDecimal("100,00"))
        expect(cart_with_one_item.allow_credit_payment?).to be_true
      end
    end

    context "when cart#subtotal is lower than R$ 100" do
      it "returns false" do
        cart_with_one_item.stub(:sub_total).and_return(BigDecimal("99,00"))
        expect(cart_with_one_item.allow_credit_payment?).to be_false
      end
    end
  end

  context "when add item" do
    it "should return nil when has gift product in cart and is not gift" do
      cart = subject
      cart.stub(has_gift_items?: true)
      cart.add_item(basic_shoe_35).should eq(nil)
    end

    it "should return nil when no has available for quantity" do
      basic_shoe_35.stub(available_for_quantity?: false)
      subject.add_item(basic_shoe_35).should eq(nil)
    end

    it "should add item" do
      expect {
        item = cart.add_item(basic_shoe_35, 2)
        item.should be_kind_of(CartItem)
        item.cart_id.should eq(cart.id)
        item.variant_id.should eq(basic_shoe_35.id)
        item.quantity.should eq(2)
        item.gift_position.should eq(0)
        item.gift.should eq(false)
      }.to change{CartItem.count}.by(1)
    end

    it "should add item with gift discount" do
      expect {
        item = cart.add_item(basic_shoe_35, 1, 2, true)
        item.should be_kind_of(CartItem)
        item.cart_id.should eq(cart.id)
        item.variant_id.should eq(basic_shoe_35.id)
        item.quantity.should eq(1)
        item.gift_position.should eq(2)
        item.gift.should eq(true)
      }.to change{CartItem.count}.by(1)
    end

    it "should update quantity when product exist in cart item" do
      cart.add_item(basic_shoe_35, 1)
      variant = cart.items.first
      cart.add_item(basic_shoe_35, 10)
      variant.reload.quantity.should eq(10)
    end
  end

  it "should sum quantity of cart items" do
    cart_with_items.items_total.should eq(2)
  end

  it "should clear all cart items" do
    cart = cart_with_items
    expect {
      cart_with_items.clear
    }.to change{CartItem.count}.by(-1)
  end

  it "should return true when at least one gift item" do
    cart_with_gift.has_gift_items?.should be(true)
  end

  it "should return false when no has gift item" do
    cart_with_items.has_gift_items?.should be(false)
  end

  describe "#complete_look_product_ids_in_cart" do
    let(:cart_with_3_items) { FactoryGirl.create(:cart_with_3_items) }

    context "when cart contains the complete look" do
      it "returns the complete look product ids set" do
        cart_with_3_items.items.each do |item|
          cart_with_3_items.items.first.product.relate_with_product(item.product) unless cart_with_3_items.items.first == item
        end
        cart_with_3_items.complete_look_product_ids_in_cart.sort.should eq(cart_with_3_items.items.map{|i| i.product.id}.sort)
      end
    end

    context "when cart doesn't contain the complete look" do
      it "returns an empty set" do
        cart_with_3_items.complete_look_product_ids_in_cart.sort.should be_empty
      end
    end

  end
end
