require 'spec_helper'
describe GiftDiscountService do
  let(:first_price)  { BigDecimal.new("69.90") }
  let(:second_price) { BigDecimal.new("89.90") }
  let(:third_price)  { BigDecimal.new("119.90") }

  let(:first_product_id) { 7 }
  let(:second_product_id) { 8 }
  let(:third_product_id) { 9 }

  describe ".percents" do
    it "returns the list of product decimals multipliers" do
      described_class.percents.should == [1, 0.8, 0.6]
    end
    
    it "uses only BigDecimal values" do
      described_class.percents.each do |value|
        value.should be_an_instance_of BigDecimal
      end
    end
  end

  describe ".price_for_product" do
    let(:product) { double(:product, :retail_price => first_price) }

    it "finds the product with the received product id" do
      Product.should_receive(:find).with(first_product_id)
      described_class.price_for_product(first_product_id)
    end

    context "when no product is found" do
      it "returns nil" do
        Product.stub(:find).with(first_product_id).and_return(nil)
        described_class.price_for_product(first_product_id).should be_nil
      end
    end

    context "when the product is found" do
      it "gets the product retail price and returns it" do
        Product.stub(:find).with(first_product_id).and_return(product)
        product.should_receive(:retail_price).and_return(69.90)
        described_class.price_for_product(first_product_id) == 69.90
      end
    end

    context "when passing a position" do
      before do
        Product.stub(:find).with(first_product_id).and_return(product)
      end

      context "and position is 0" do
        it "returns the product retail price" do
          described_class.price_for_product(first_product_id, 0).should == first_price
        end
      end

      context "and position is 1" do
        it "returns the product retail price with 20% off" do
          described_class.price_for_product(first_product_id, 1).should == first_price - 0.20*first_price
        end
      end

      context "and product position is 2" do
        it "returns the product retail price with 40% off" do
          described_class.price_for_product(first_product_id, 2).should == first_price - 0.40*first_price
        end
      end

    end
  end

  describe ".total_price_for_products" do
    
    context "when products list has one product id" do
      let(:products) { [first_product_id] }
      
      it "calls price_for_product for each product id passing the correct position in the list" do
        described_class.should_receive(:price_for_product).with(first_product_id,0).and_return(first_price)
        described_class.total_price_for_products(products)
      end
      
      it "returns the price of the product" do
        described_class.stub(:price_for_product).and_return(first_price)
        described_class.total_price_for_products(products).should == first_price
      end
      
    end

    context "when products list has two products" do
      let(:products) { [first_product_id, second_product_id] }
      
      it "calls price_for_product for each product id passing the correct position in the list" do
        described_class.should_receive(:price_for_product).with(first_product_id,0).and_return(first_price)
        described_class.should_receive(:price_for_product).with(second_product_id,1).and_return(second_price)
        
        described_class.total_price_for_products(products)
      end
      
      it "returns the sum of the products' prices" do
        described_class.should_receive(:price_for_product).and_return(first_price)
        described_class.should_receive(:price_for_product).and_return(second_price)
        
        described_class.total_price_for_products(products).should == first_price + second_price
      end
    end

    context "when products list has three products" do
      let(:products) { [first_product_id, second_product_id, third_product_id] }
      
      it "calls price_for_product for each product id passing the correct position in the list" do
        described_class.should_receive(:price_for_product).with(first_product_id,0).and_return(first_price)
        described_class.should_receive(:price_for_product).with(second_product_id,1).and_return(second_price)
        described_class.should_receive(:price_for_product).with(third_product_id,2).and_return(third_price)
        
        described_class.total_price_for_products(products)
      end
      
      it "returns the sum of the products' prices" do
        described_class.should_receive(:price_for_product).and_return(first_price)
        described_class.should_receive(:price_for_product).and_return(second_price)
        described_class.should_receive(:price_for_product).and_return(third_price)
        
        described_class.total_price_for_products(products).should == first_price + second_price + third_price
      end
    end
  end
end