require 'spec_helper'
describe GiftDiscountService do
  let(:first_price) { 69.90 }
  let(:second_price) { 119.90 }
  let(:third_price) { 119.90 }

  let(:first_product)  { double(:first_product, :retail_price => first_price)   }
  let(:second_product) { double(:second_product, :retail_price => second_price) }
  let(:third_product)  { double(:third_product, :retail_price => third_price)   }

  describe ".percents" do
    it "returns the list of product percents multiplier" do
      described_class.percents.should == [1, 0.8, 0.6]
    end
  end

  describe ".price_for_product" do
    let(:product) { double(:product, :retail_price => 69.90) }
    let(:product_id) { 7 }

    it "finds the product with the received product id" do
      Product.should_receive(:find).with(product_id)
      described_class.price_for_product(product_id)
    end

    context "when no product is find" do
      it "returns nil" do
        Product.should_receive(:find).with(product_id).and_return(nil)
        described_class.price_for_product(product_id).should be_nil
      end
    end

    context "when the product is found" do
      it "gets the product retail price and returns it" do
        Product.stub(:find).with(product_id).and_return(product)
        product.should_receive(:retail_price).and_return(69.90)
        described_class.price_for_product(product_id) == 69.90
      end
    end

    context "when passing a position" do
      before do
        Product.stub(:find).with(product_id).and_return(product)
      end

      context "and position is 0" do
        it "returns the product retail price" do
          described_class.price_for_product(product_id,0).should == 69.90
        end
      end

      context "and position is 1" do
        it "returns the product retail price with 20% off" do
          described_class.price_for_product(product_id,1).should == 69.90 * 0.8
        end
      end

      context "and product position is 2" do
        it "returns the product retail price multiplied by 0.6" do
          described_class.price_for_product(product_id,2).should == 69.90 * 0.6
        end
      end

    end
  end

  describe ".total_price_with_discount" do
    context "when products list has only one product" do
      let(:products) { [first_product] }

      it "gets the first product retail_price" do
        first_product.should_receive(:retail_price)
        described_class.total_price_with_discount([first_product])
      end

      it "returns the first product product retail price" do
        described_class.total_price_with_discount([first_product]).should == first_price
      end
    end

    context "when products list has two products" do
      let(:products) { [first_product, second_product] }

      it "gets first and second products retail_prices" do
        first_product.should_receive(:retail_price)
        second_product.should_receive(:retail_price)
        described_class.total_price_with_discount(products)
      end

      it "returns the sum of both products applying 20% discount on the second product" do
        described_class.total_price_with_discount(products).should == first_price + second_price*0.8
      end
    end

    context "when products list has three products" do
      let(:products) { [first_product, second_product, third_product] }

      it "gets first and second products retail_prices" do
        first_product.should_receive(:retail_price)
        second_product.should_receive(:retail_price)
        third_product.should_receive(:retail_price)
        described_class.total_price_with_discount(products)
      end

      it "returns the sum of both products applying 20% discount on the second product and 40% on the third price" do
        described_class.total_price_with_discount(products).should ==
          first_price + second_price*0.8 + third_price*0.6
      end
    end
  end
end