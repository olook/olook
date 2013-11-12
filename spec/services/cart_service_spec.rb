require "spec_helper"

describe CartService do

  let(:gift_wrap_price) { 5.00 }

  let(:user) { FactoryGirl.create :user }
  let(:address) { FactoryGirl.create(:address, :user => user) }
  let(:cart) { FactoryGirl.create(:cart_with_items, :user => user) }
  let(:shipping_service) { FactoryGirl.create :shipping_service }
  let(:freight) { { :price => 12.34, :cost => 2.34, :delivery_time => 2, :shipping_service_id => shipping_service.id, :address_id => address.id} }
  let(:promotion) { FactoryGirl.create :first_time_buyers }
  let(:coupon_of_value) { FactoryGirl.create :standard_coupon}
  let(:coupon_of_percentage) { FactoryGirl.create :percentage_coupon}
  let(:payment) { FactoryGirl.create :debit }
  let(:cart_service) { CartService.new({
    :cart => cart
  }) }

  context "#allow_credit_payment?" do
    it "should delegate to cart when no promotion exists" do
      cart.should_receive(:allow_credit_payment?)
      cart_service.allow_credit_payment?
    end
  end

  it "should return gift wrap price" do
    CartService.gift_wrap_price.should eq(gift_wrap_price)
  end

  context "when initialize" do
    [:cart].each do |attribute|
      it "should set #{attribute}" do
        value = mock
        cart_service = CartService.new({attribute => value})
        cart_service.send("#{attribute}").should be(value)
      end
    end
  end

  context ".freight_price" do
    it "should return zero when freight is not available" do
      cart_service = CartService.new({})
      cart_service.stub(:freight).and_return({})
      cart_service.freight_price.should eq(0)
    end

    it "should return price" do
      cart_service = CartService.new({})
      cart_service.stub(:freight).and_return({:price => 10.0})
      cart_service.freight_price.should eq(10.0)
    end
  end

  context ".freight_city" do
    it "should return empty when freight is not available" do
      cart_service = CartService.new({})
      cart_service.stub(:freight).and_return({})
      cart_service.freight_city.should eq("")
    end

    it "should return city" do
      cart_service = CartService.new({})
      cart_service.stub(:freight).and_return({:city => "XPTO2.0"})
      cart_service.freight_city.should eq("XPTO2.0")
    end
  end

  context ".freight_state" do
    it "should return empty when freight is not available" do
      cart_service = CartService.new({})
      cart_service.stub(:freight).and_return({})
      cart_service.freight_state.should eq("")
    end

    it "should return state" do
      cart_service = CartService.new({})
      cart_service.stub(:freight).and_return({:state => "XPTO"})
      cart_service.freight_state.should eq("XPTO")
    end
  end

  context ".item_price" do
    it "should return price from master variant" do
      cart.items.first.variant.product.master_variant.update_attribute(:price, 20)
      cart_service.item_price(cart.items.first).should eq(20)
    end
  end

  context ".item_retail_price" do
    before :each do
      cart.items.first.variant.product.master_variant.update_attribute(:price, 20)
    end

    it "should return retail price from master variant" do
      cart.items.first.variant.product.master_variant.update_attribute(:retail_price, 18)
      cart_service.item_retail_price(cart.items.first).should eq(18)
    end

    context "when has coupon of percentage" do
      it "should return current retail price if discount price is less than current" do
        cart.items.first.variant.product.master_variant.update_attribute(:retail_price, 14)
        cart_service.cart.coupon = coupon_of_percentage
        cart_service.item_retail_price(cart.items.first).should eq(14)
      end

      it "should return discount price if discount price is greater than current" do
        cart.items.first.variant.product.master_variant.update_attribute(:retail_price, 18)
        cart_service.cart.coupon = coupon_of_percentage
        cart_service.item_retail_price(cart.items.first).should eq(16)
      end
    end

    context "when there is a coupon product" do

      let(:product_coupon) { FactoryGirl.create(:product_coupon)}

      before do
        cart.items.first.variant.product.master_variant.update_attribute(:price, 100)
        cart_service.stub(:freight_price).and_return(0.0)
        cart_service.cart.coupon = product_coupon
      end

      it "should apply 30% discount" do
        product_coupon.stub(:apply_discount_to?, 9640).and_return(true)
        cart_service.item_retail_price(cart.items.first).should == 80
      end

      it "should not apply discount" do
        product_coupon.stub(:apply_discount_to?, 9640).and_return(false)
        cart_service.item_retail_price(cart.items.first).should == 100
      end
    end
  end

  context ".item_promotion?" do
    it "should return true if retail_price is different of price" do
      item_mock = mock(:price => 10, :retail_price => 9, :has_adjustment? => true)
      cart_service.item_promotion?(item_mock).should eq(true)
    end

    it "should return false if retail_price is equal price" do
      item_mock = mock(:price => 10, :retail_price => 10, :has_adjustment? => false)
      cart_service.item_promotion?(item_mock).should eq(false)
    end
  end

  context ".item_price_total" do
    it "should return item_price muliply by item quantity" do
      cart_service.stub(:item_price => 10)
      item = double(CartItem, :quantity => 5)
      cart_service.item_price_total(item).should eq(50)
    end
  end

  context ".item_retail_price_total" do
    it "should return item_retail_price muliply by item quantity" do
      cart_service.stub(:item_retail_price => 10)
      item = double(CartItem, :quantity => 5)
      cart_service.item_retail_price_total(item).should eq(50)
    end
  end

  context ".item_discount_percent" do
    before :each do
      cart.items.first.variant.product.master_variant.update_attribute(:price, 20)
    end

    # Test that hits #get_retail_price_for_item
    it "should return zero percent when has no discounts" do
      cart_service.item_discount_percent(cart.items.first).should eq(0)
    end

    it "should return percent when has olooklet" do
      cart.items.first.variant.product.master_variant.update_attribute(:retail_price, 18)
      cart_service.item_discount_percent(cart.items.first).should eq(10)
    end

    it "should return percent when has coupon of percentage" do
      cart_service.cart.coupon = coupon_of_percentage
      cart_service.item_discount_percent(cart.items.first).should eq(coupon_of_percentage.value)
    end

 end

  context ".item_discount_origin" do
    before :each do
      cart.items.first.variant.product.master_variant.update_attribute(:price, 20)
    end

    it "should return empty when has no discounts" do
      cart_service.item_discount_origin(cart.items.first).should eq("")
    end

    it "should return olooklet description when has olooklet" do
      cart.items.first.variant.product.master_variant.update_attribute(:retail_price, 18)
      cart_service.item_discount_origin(cart.items.first).should eq("Olooklet: 10% de desconto")
    end

    it "should return coupon description when has coupon of percentage" do
      cart_service.cart.coupon = coupon_of_percentage
      cart_service.item_discount_origin(cart.items.first).should eq("Desconto de 20% do cupom FOOBAR000")
    end

  end

  context ".item_discount_origin_type" do
    before :each do
      cart.items.first.variant.product.master_variant.update_attribute(:price, 20)
    end

    it "should return empty when has no discounts" do
      cart_service.item_discount_origin_type(cart.items.first).should eq("")
    end

    it "should return olooklet when has olooklet" do
      cart.items.first.variant.product.master_variant.update_attribute(:retail_price, 18)
      cart_service.item_discount_origin_type(cart.items.first).should eq(:olooklet)
    end

    it "should return coupon when has coupon of percentage" do
      cart_service.cart.coupon = coupon_of_percentage
      cart_service.item_discount_origin_type(cart.items.first).should eq(:coupon)
    end

  end

  context ".item_discounts" do
    before :each do
      cart.items.first.variant.product.master_variant.update_attribute(:price, 20)
    end

    it "should return empty when has no discounts" do
      cart_service.item_discounts(cart.items.first).should eq([])
    end

    it "should return olooklet when has olooklet" do
      cart.items.first.variant.product.master_variant.update_attribute(:retail_price, 18)
      cart_service.item_discounts(cart.items.first).should eq([:olooklet])
    end

    it "should return coupon when has coupon of percentage" do
      cart.items.first.variant.product.master_variant.update_attribute(:retail_price, 18)
      cart_service.cart.coupon = coupon_of_percentage
      cart_service.item_discounts(cart.items.first).should eq([:coupon])
    end

  end

  context ".subtotal" do
    it "should return zero when no has items" do
      cart_service = CartService.new({})
      cart_service.subtotal(:price).should eq(0)
    end

    it "should return sum of price_total for all items" do
      cart_service.stub(:item_price_total => 100)
      cart_service.subtotal(:price).should eq(100)
    end

    it "should return sum of retail_price_total for all items" do
      cart_service.stub(:item_retail_price_total => 50)
      cart_service.subtotal(:retail_price).should eq(50)
    end
  end

  context ".total_increase" do
    it "should return zero when no has freight and gift wrap" do
      cart.gift_wrap = false;
      cart_service = CartService.new({:cart => cart})
      cart_service.total_increase.should eq(0)
    end

    it "should sum gift wrap" do
      cart.gift_wrap = true;
      cart_service = CartService.new({:cart => cart})
      cart_service.total_increase.should eq(gift_wrap_price)
    end

    it "should sum freight price" do
      cart_service = CartService.new({:cart => cart})
      cart_service.stub(:freight).and_return({:price => 10.0})
      cart_service.total_increase.should eq(10.0)
    end
  end

  context ".total_coupon_discount" do
    before :each do
      master_variant = cart.items.first.variant.product.master_variant
      master_variant.update_attribute(:price, 50)
      master_variant.update_attribute(:retail_price, 50)
    end

    it "should return zero when no has coupon" do
      cart_service.total_coupon_discount.should eq(0)
    end

    it "should return zero when coupon is for percentage" do
      cart_service.cart.coupon = coupon_of_percentage
      cart_service.total_coupon_discount.should eq(0)
    end

    it "should return correct value when coupon is less than maximum value" do
      cart_service.cart.coupon = coupon_of_value
      cart_service.total_coupon_discount.should eq(50)
    end

    it "should return correct value when coupon is greater than maximum value and has freight" do
      cart_service.stub(:freight).and_return(freight)
      coupon_of_value.update_attribute(:value, 100)
      cart_service.cart.coupon = coupon_of_value
      cart_service.total_coupon_discount.should eq(100)
    end

    it "should return correct value when coupon is greater than maximum value and has no freight" do
      cart_service.stub(:freight).and_return(nil)
      coupon_of_value.update_attribute(:value, 105)
      cart_service.cart.coupon = coupon_of_value
      cart_service.total_coupon_discount.should eq(100)
    end
  end

  context ".is_minimum_payment?" do
    before :each do
      master_variant = cart.items.first.variant.product.master_variant
      master_variant.update_attribute(:price, 50)
      master_variant.update_attribute(:retail_price, 50)
      cart.update_attribute(:use_credits, true)
    end

    context "when freight price is greater than minimum value" do
      before :each do
        cart_service.stub(:freight).and_return(freight.merge!(:price => 10))
      end

      it "and there are no credits to the total purchase should return false" do
        cart_service.cart.use_credits = false
        cart_service.is_minimum_payment?.should be_false
      end

    end

    context "when freight price is less than minimum value" do
      before :each do
        cart_service.stub(:freight).and_return(freight.merge!(:price => 3))
      end

      it "and there are no credits to the total purchase should return false" do
        cart_service.cart.use_credits = false
        cart_service.is_minimum_payment?.should be_false
      end
    end
  end

  context ".total_discount_by_type" do
    it "should sum total cupon when type is coupon" do
      cart_service.stub(:total_coupon_discount).and_return(100)
      cart_service.total_discount_by_type(:coupon).should eq(100)
    end

    it "should sum discount value when discount type match in item" do
      cart.items.first.variant.product.master_variant.update_attribute(:price, 20)
      cart_service.cart.coupon = coupon_of_percentage
      cart_service.total_discount_by_type(:coupon).should eq(4.0)
    end
  end

  context ".calculate_discounts" do
    let(:user_credit) { mock_model(UserCredit, total: 50) }
    let(:empty_user_credit) { mock_model(UserCredit, total: 0) }

    before :each do
      master_variant = cart.items.first.variant.product.master_variant
      master_variant.update_attribute(:price, 100)
      master_variant.update_attribute(:retail_price, 100)
      cart_service.cart.coupon = nil
      cart.items.first.quantity = 1
    end

    it "returns discounts = billet_discount when payment type is billet" do
      Setting.should_receive(:billet_discount_available).and_return(true)
      Setting.should_receive(:billet_discount_percent).and_return("5")
      cart_service.calculate_discounts(Billet.new).fetch(:discounts).should eq([:billet_discount, :debit_discount])
    end

    it "applies billet_discount on the retail_value" do
      Setting.should_receive(:billet_discount_available).and_return(true)
      Setting.should_receive(:billet_discount_percent).and_return("5")
      cart_service.calculate_discounts(Billet.new).fetch(:billet_discount).should eq(5.0)
    end

    it "applies billet_discount on the retail_value after applying coupon of value" do
      Setting.should_receive(:billet_discount_available).and_return(true)
      Setting.should_receive(:billet_discount_percent).and_return("5")
      cart_service.cart.coupon = coupon_of_value
      cart_service.calculate_discounts(Billet.new).fetch(:billet_discount).should eq(2.5)
    end

    it "applies billet_discount on the retail_value after applying loyalty_program credits" do
      Setting.should_receive(:billet_discount_available).and_return(true)
      Setting.should_receive(:billet_discount_percent).and_return("5")
      cart_service.cart.user.should_receive(:user_credits_for).with(:loyalty_program).and_return(user_credit)
      cart_service.cart.user.should_receive(:user_credits_for).with(:invite).and_return(empty_user_credit)
      cart_service.cart.user.should_receive(:user_credits_for).with(:redeem).and_return(empty_user_credit)
      cart_service.cart.use_credits = true
      cart_service.calculate_discounts(Billet.new).fetch(:billet_discount).should eq(2.5)
    end

    it "applies billet_discount on the retail_value after applying invite credits" do
      Setting.should_receive(:billet_discount_available).and_return(true)
      Setting.should_receive(:billet_discount_percent).and_return("5")
      cart_service.cart.user.should_receive(:user_credits_for).with(:loyalty_program).and_return(empty_user_credit)
      cart_service.cart.user.should_receive(:user_credits_for).with(:invite).and_return(user_credit)
      cart_service.cart.user.should_receive(:user_credits_for).with(:redeem).and_return(empty_user_credit)
      cart_service.cart.use_credits = true
      cart_service.calculate_discounts(Billet.new).fetch(:billet_discount).should eq(2.5)
    end

    it "applies billet_discount on the retail_value after applying invite credits" do
      Setting.should_receive(:billet_discount_available).and_return(true)
      Setting.should_receive(:billet_discount_percent).and_return("5")
      cart_service.cart.user.should_receive(:user_credits_for).with(:loyalty_program).and_return(empty_user_credit)
      cart_service.cart.user.should_receive(:user_credits_for).with(:invite).and_return(empty_user_credit)
      cart_service.cart.user.should_receive(:user_credits_for).with(:redeem).and_return(user_credit)
      cart_service.cart.use_credits = true
      cart_service.calculate_discounts(Billet.new).fetch(:billet_discount).should eq(2.5)
    end
  end

  context ".active_discounts" do
    it "should sum discounts of items" do
      cart.items.first.dup.save
      cart_service.should_receive(:item_discounts).and_return([:olooklet, :promotion])
      cart_service.active_discounts.should eq([:olooklet, :promotion])
    end
  end

  context ".has_more_than_one_discount?" do
    it "should return false when has no discount" do
      cart_service.stub(:item_discounts => [])
      cart_service.has_more_than_one_discount?.should eq(false)
    end

    it "should return false when has one discount" do
      cart_service.stub(:item_discounts => [:olooklet])
      cart_service.has_more_than_one_discount?.should eq(false)
    end

    it "should return true when has two or more discounts" do
      cart_service.stub(:item_discounts => [:olooklet, :promotion])
      cart_service.has_more_than_one_discount?.should eq(true)
    end
  end

  context "#total" do
    it "should sum retail price of items" do
      cart_service.stub(:total_increase).and_return(0)
      cart_service.stub(:total_discount).and_return(0)
      cart_service.cart.stub(:sub_total).and_return(100)

      cart_service.total.should eq(100)
    end

    it "should sum increase values" do
      cart_service.stub(:total_discount).and_return(0)
      cart_service.stub(:cart_sub_total).and_return(0)
      cart_service.should_receive(:total_increase).and_return(25)
      cart_service.total.should eq(25)
    end

    it "should subtract discounts values" do
      cart_service.stub(:total_increase).and_return(0)
      cart_service.stub(:cart_sub_total).and_return(100)
      cart_service.should_receive(:total_discount).and_return(25)
      cart_service.total.should eq(75)
    end

    it "should is minimum value when total is less than minimum value" do
      cart_service.stub(:total_increase).and_return(0)
      cart_service.stub(:cart_sub_total).and_return(0)
      cart_service.stub(:total_discount).and_return(0)
      cart_service.total.should eq(Payment::MINIMUM_VALUE)
    end
  end

  context "insert a order" do
    let(:tracking) { FactoryGirl.create :tracking }
    it "should a valid cart is required" do
      expect {
        CartService.new({}).generate_order!(Payment::GATEWAYS[:moip])
      }.to raise_error(ActiveRecord::RecordNotFound, 'A valid cart is required for generating an order.')
    end

    it "should a valid user is required" do
      expect {
        cart.user = nil
        CartService.new({:cart => cart}).generate_order!(Payment::GATEWAYS[:moip])
      }.to raise_error(ActiveRecord::RecordNotFound, 'A valid user is required for generating an order.')
    end

    it "should create" do
      expect {
        cart_service = CartService.new({:cart => cart})
        cart_service.stub(:freight).and_return(freight)
        cart_service.stub(:total_credits_discount => 0)
        cart_service.stub(:total_discount => 10)
        cart_service.stub(:total_increase => 20)
        cart_service.stub(:total => 30)
        cart_service.stub(:subtotal => 40)
        cart_service.stub(:item_price => 10)
        cart_service.stub(:normalize_retail_price => 20)
        cart_service.should_receive(:create_freebies_line_items_and_update_subtotal)
        cart_service.should_receive(:normalize_retail_price)

        order = cart_service.generate_order!(Payment::GATEWAYS[:moip], tracking)

        order.cart.should eq(cart)
        order.credits.should eq(0)
        order.user_id.should eq(user.id)
        order.restricted.should eq(false)
        order.gift_wrap.should eq(false)
        order.amount_discount.should eq(10)
        order.amount_increase.should eq(20)
        order.amount_paid.should eq(30)
        order.subtotal.should eq(40)
        order.user_first_name.should eq(user.first_name)
        order.user_last_name.should eq(user.last_name)
        order.user_email.should eq(user.email)
        order.user_cpf.should eq(user.cpf)

        cart.items.map do |item|
          line_item = order.line_items.where(
            :variant_id => item.variant.id,
            :quantity => item.quantity,
            :gift => item.gift
          ).first
          line_item.price.should eq(10)
          line_item.retail_price.should eq(20)
        end

        freight.each do |key, value|
          order.freight.send("#{key}").should eq(value)
        end

      }.to change{Order.count}.by(1)
    end

    context "when variant hash freebies" do

      let(:freebie) { FactoryGirl.create(:basic_bag_simple) }

      before do
        FactoryGirl.create(:freebie_variant, :variant => cart.items.first.variant, :freebie => freebie)
        cart_service = CartService.new({:cart => cart})
        cart_service.stub(:freight).and_return(freight)
      end

      it "creates freebies line items" do
        order = Order.new
        item = cart.items.first
        cart_service.create_freebies_line_items_and_update_subtotal(order, item)
        order.line_items.size.should eq(1)
        order.line_items.first.variant.id.should eq(freebie.id)
        order.line_items.first.is_freebie.should eq(true)
        order.line_items.first.price.should eq(0.1)
        order.line_items.first.retail_price.should eq(0.1)
        order.line_items.first.quantity.should eq(item.quantity)
      end

      it "increments amount_discount for each freebie added" do
        order = Order.new
        cart_service.create_freebies_line_items_and_update_subtotal(order, cart.items.first)
        order.amount_discount.should eq(0.1)
      end

    end

  end

  context "when cart has 1 item of price 20" do

    before do
      @cart_item = cart.items.first
      @cart_item.update_attribute(:quantity, 1)
      @cart_item.variant.product.master_variant.update_attribute(:price, 20)
    end

    context "when item doesnt have promotion adjustment" do

      it "should return current retail price" do
        @cart_item.variant.product.master_variant.update_attribute(:retail_price, 10)
        cart_service.item_retail_price(@cart_item).should eq(10)
      end

      pending " TODO !!! More specs "
    end

    context "when item has a promotion adjustment" do

      before do
        @cart_item.stub(:adjustment_value).and_return(2)
      end

      it "should return promotion price" do
        @cart_item.variant.product.master_variant.update_attribute(:retail_price, 19)
        cart_service.item_retail_price(@cart_item).should eq(18)
      end

      context "when there is a percentage coupon that gives more discount than promotion" do
        before do
          coupon_of_percentage.update_attribute(:value, 30.0)
          cart_service.cart.coupon = coupon_of_percentage
        end

        it "should return coupon as discount" do
          cart_service.item_discounts(@cart_item).should eq([:coupon])
        end

        it "should return price with coupon discount" do
          cart_service.item_retail_price(@cart_item).should eq(14)
        end
      end
    end
  end

  describe "#normalize_retail_price" do

    context "when retail price is not 0" do

      it "should return the retail price" do
        order = Order.new({amount_discount: 0, subtotal: 0})
        cart_service.should_receive(:item_retail_price).and_return(100)
        cart_service.normalize_retail_price(order, cart.items.first).should eq(100)
      end

      it "should not affect order" do
        order = Order.new({amount_discount: 0, subtotal: 0})
        cart_service.should_receive(:item_retail_price).and_return(100)
        cart_service.normalize_retail_price(order, cart.items.first)
        order.amount_discount.should eq(0)
        order.subtotal.should eq(0)
      end

    end

    context "when retail price is 0" do

      it "should return the retail price = 0.1" do
        order = Order.new({amount_discount: 0, subtotal: 0})
        cart_service.should_receive(:item_retail_price).and_return(0)
        cart_service.normalize_retail_price(order, cart.items.first).should eq(0.1)
      end

      it "should affect order discount and subtotal" do
        order = Order.new({amount_discount: 0, subtotal: 0})
        cart_service.should_receive(:item_retail_price).and_return(0)
        cart_service.normalize_retail_price(order, cart.items.first)
        order.amount_discount.should eq(0.1)
        order.subtotal.should eq(0.1)
      end

    end
  end

  describe "#has_percentage_coupon?" do
    context "when cart_service#cart has coupon" do
      let(:cart) { FactoryGirl.build(:clean_cart) }
      let(:cart_service) { described_class.new ({ cart: cart }) }
      let(:coupon) { FactoryGirl.build(:coupon) }

      before do
        cart.stub(:coupon).and_return(coupon)
      end

      context "and coupon is percentage" do

        before do
          coupon.stub(:is_percentage?).and_return(true)
        end

        subject { cart_service.has_percentage_coupon? }
        it { should be_true }
      end

      context "but coupon is not percentage" do

        subject { cart_service.has_percentage_coupon? }
        it { should be_false }
      end
    end

    context "when cart_service#cart hasn't coupon" do

      let(:cart) { FactoryGirl.build(:clean_cart) }
      let(:cart_service) { described_class.new ({ cart: cart }) }

      subject { cart_service.has_percentage_coupon? }

      it { should be_false }
    end
  end

  describe "#price_with_coupon_for" do
    let(:product) { FactoryGirl.build(:shoe) }
    let(:cart) { FactoryGirl.build(:clean_cart) }
    subject { described_class.new({ cart: cart }) }

    before do
      product.stub(:retail_price).and_return(BigDecimal('130.00'))
    end

    context "when there's no applied coupon" do
      it { expect(subject.price_with_coupon_for product).to eq(product.retail_price) }
    end

    context "when coupon there's coupon" do
      let(:coupon) { FactoryGirl.build(:coupon, value: 50.00) }

      before do
        cart.stub(:coupon).and_return(coupon)
      end

      context "and coupon is not percentage" do
        before do
          coupon.stub(:is_percentage?).and_return(false)
        end
        it { expect(subject.price_with_coupon_for product).to eq(product.retail_price) }
      end

      context "and coupon is percentage" do
        before do
          coupon.stub(:is_percentage?).and_return(true)
          product.stub(:price).and_return(BigDecimal('130.00'))
        end

        let(:value_with_discount) { BigDecimal("65.00") }

        it { expect(subject.price_with_coupon_for product).to eq(value_with_discount) }

      end

    end

    context "when given product has promotion" do
      before do
        product.stub(:promotion?).and_return(true)
      end

      it { expect(subject.price_with_coupon_for product).to eq(product.retail_price) }
    end
  end
end
