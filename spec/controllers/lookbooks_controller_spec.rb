require 'spec_helper'

describe LookbooksController do
  let(:products) { [:product_a, :product_b]}

  describe "GET 'verao_chic'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        Product.should_receive(:find_by_id).and_return(@returned_product)
        product = [@product_a]
        get 'verao_chic'
        assigns(product).should == @returned_product
      end

      it "should be succesfull" do
        Product.stub(:find).and_return(products)
        get 'verao_chic'
        response.should be_success
      end
    end
  end

  describe "GET 'color_block'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        Product.should_receive(:find_by_id).and_return(products)
        get 'color_block'
        assigns(:products).should == products
      end

      it "should be succesfull" do
        Product.stub(:find_by_id).and_return(products)
        get 'color_block'
        response.should be_success
      end
    end
  end

  describe "GET 'golden_grace'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        Product.should_receive(:find_by_id).and_return(products)
        get 'golden_grace'
        assigns(:products).should == products
      end

      it "should be succesfull" do
        Product.stub(:find_by_id).and_return(products)
        get 'golden_grace'
        response.should be_success
      end
    end
  end

  describe "GET 'lets_party'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        Product.should_receive(:find_by_id).and_return(products)
        get 'lets_party'
        assigns(:products).should == products
      end

      it "should be succesfull" do
        Product.stub(:find_by_id).and_return(products)
        get 'lets_party'
        response.should be_success
      end
    end
  end

  describe "GET 'flores'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        Product.should_receive(:find_by_id).and_return(products)
        get 'flores'
        assigns(:products).should == products
      end

      it "should be succesfull" do
        Product.stub(:find_by_id).and_return(products)
        get 'flores'
        response.should be_success
      end
    end
  end
end
