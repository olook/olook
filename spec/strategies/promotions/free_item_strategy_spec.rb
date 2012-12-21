require 'spec_helper'

describe Promotions::FreeItemStrategy do
  let(:user) { double(:user) }
  let(:promotion) { double(:promotion, param: "3") }
  let(:cart) {FactoryGirl.create(:cart_with_items)}
  let(:product) { FactoryGirl.create(:basic_shoe) }
  subject {  described_class.new(promotion, user) }

  describe ".initialize" do
    it "receive :promotion and :user" do
      subject.promotion.should eq(promotion)
      subject.user.should eq(user)
    end
  end

  describe "#matches?" do
    context "when cart has only 1 item" do
      it "does not match" do
        subject.matches?(cart).should be_false
      end
    end
  end

  describe "#calculate_value" do
    let(:cart_item) { mock_model(CartItem, price: 100.00, id: 1, product: product) }
    let(:second_cart_item) { mock_model(CartItem, price: 200.00, id: 2, product: product) }

    context "when the cart has 1 item" do
      it "returns full price of cart_item" do
        subject.calculate_value([cart_item], cart_item).should eq(cart_item.price)
      end
    end

    context "when the cart has 2 item" do
      let(:cart_items) { [cart_item, second_cart_item] }
      it "returns full price of the first cart_items" do
        subject.calculate_value(cart_items, cart_item).should eq(cart_item.price)
      end
      it "returns full price of the second cart_items" do
        subject.calculate_value(cart_items, second_cart_item).should eq(second_cart_item.price)
      end
    end

    context "when the cart has 3 items with equal values" do
      let(:third_cart_item) { mock_model(CartItem, price: 100.00, id: 3, product: product) }
      let(:cart_items) { [cart_item, second_cart_item, third_cart_item] }
      it "returns 0 for the cart_item with lower price and lower id" do
        subject.calculate_value(cart_items, cart_item).should eq(0)
      end
      it "returns full price of the second cart_items" do
        subject.calculate_value(cart_items, second_cart_item).should eq(200)
      end
      it "returns full price for the cart_item with lower price and greater id" do
        subject.calculate_value(cart_items, third_cart_item).should eq(100)
      end
    end

    context "when the cart has 3 item with different values" do
      let(:third_cart_item) { mock_model(CartItem, price: 50.00, id: 3, product: product) }
      let(:cart_items) { [cart_item, second_cart_item, third_cart_item] }
      it "returns 0 for the cart_item with lower price" do
        subject.calculate_value(cart_items, third_cart_item).should eq(0)
      end
    end

    context "when the cart has 4 item with equal values" do
      let(:third_cart_item) { mock_model(CartItem, price: 100.00, id: 3, product: product) }
      let(:fourth_cart_item) { mock_model(CartItem, price: 50.00, id: 4, product: product) }
      let(:cart_items) { [cart_item, second_cart_item, third_cart_item, fourth_cart_item] }
      it "returns full price of the first cart_items" do
        subject.calculate_value(cart_items, cart_item).should eq(cart_item.price)
      end

      it "returns full price of the second cart_items" do
        subject.calculate_value(cart_items, second_cart_item).should eq(second_cart_item.price)
      end

      it "returns full price of the third cart_items" do
        subject.calculate_value(cart_items, third_cart_item).should eq(third_cart_item.price)
      end

      it "returns 0 for the cart_item with lower price" do
        subject.calculate_value(cart_items, fourth_cart_item).should eq(0)
      end
    end

    context "when the cart has 6 items" do
      let(:third_cart_item) { mock_model(CartItem, price: 100.00, id: 3, product: product) }
      let(:fourth_cart_item) { mock_model(CartItem, price: 50.00, id: 4, product: product) }
      let(:fifth_cart_item) { mock_model(CartItem, price: 30.00, id: 5, product: product) }
      let(:sixth_cart_item) { mock_model(CartItem, price: 60.00, id: 6, product: product) }
      let(:cart_items) { [cart_item, second_cart_item, third_cart_item, fourth_cart_item, fifth_cart_item, sixth_cart_item] }

      it "returns full price of the first cart_items" do
        subject.calculate_value(cart_items, cart_item).should eq(cart_item.price)
      end

      it "returns full price of the second cart_items" do
        subject.calculate_value(cart_items, second_cart_item).should eq(second_cart_item.price)
      end

      it "returns full price of the third cart_items" do
        subject.calculate_value(cart_items, third_cart_item).should eq(third_cart_item.price)
      end

      it "returns 0 for the second cart_item with lower price" do
        subject.calculate_value(cart_items, fourth_cart_item).should eq(0)
      end

      it "returns 0 for the cart_item with lower price" do
        subject.calculate_value(cart_items, fifth_cart_item).should eq(0)
      end

      it "returns full price of the sixth cart_items" do
        subject.calculate_value(cart_items, sixth_cart_item).should eq(60)
      end
    end

  end
end
