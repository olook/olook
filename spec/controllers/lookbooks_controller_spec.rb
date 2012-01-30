require 'spec_helper'

describe LookbooksController do
  let(:products) { [:product_a, :product_b]}

  describe "GET 'verao'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        Product.should_receive(:find).and_return(products)
        get 'verao'
        assigns(:products).should == products
      end

      it "should be succesfull" do
        Product.stub(:find).and_return(products)
        get 'verao'
        response.should be_success
      end
    end
  end

  describe "GET 'militar'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        Product.should_receive(:find).and_return(products)
        get 'militar'
        assigns(:products).should == products
      end

      it "should be succesfull" do
        Product.stub(:find).and_return(products)
        get 'militar'
        response.should be_success
      end
    end
  end

  describe "GET 'scarpin_glamour'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        Product.should_receive(:find).and_return(products)
        get 'scarpin_glamour'
        assigns(:products).should == products
      end

      it "should be succesfull" do
        Product.stub(:find).and_return(products)
        get 'scarpin_glamour'
        response.should be_success
      end
    end
  end

  describe "GET 'fashion'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        Product.should_receive(:find).and_return(products)
        get 'fashion'
        assigns(:products).should == products
      end

      it "should be succesfull" do
        Product.stub(:find).and_return(products)
        get 'fashion'
        response.should be_success
      end
    end
  end

  describe "GET 'vintage'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        Product.should_receive(:find).and_return(products)
        get 'vintage'
        assigns(:products).should == products
      end

      it "should be succesfull" do
        Product.stub(:find).and_return(products)
        get 'vintage'
        response.should be_success
      end
    end
  end

  describe "GET 'safari'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        Product.should_receive(:find).and_return(products)
        get 'safari'
        assigns(:products).should == products
      end

      it "should be succesfull" do
        Product.stub(:find).and_return(products)
        get 'safari'
        response.should be_success
      end
    end
  end

  describe "GET 'sapatilhas'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        pending
        Product.should_receive(:find).and_return(products)
        get 'sapatilhas'
        assigns(:products).should == products
      end

      it "should be succesfull" do
        pending
        Product.stub(:find).and_return(products)
        get 'sapatilhas'
        response.should be_success
      end
    end
  end

  describe "GET 'palha'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        Product.should_receive(:find).and_return(products)
        get 'palha'
        assigns(:products).should == products
      end

      it "should be succesfull" do
        Product.stub(:find).and_return(products)
        get 'palha'
        response.should be_success
      end
    end
  end

  describe "GET 'glitter'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        pending
        Product.should_receive(:find).and_return(products)
        get 'glitter'
        assigns(:products).should == products
      end

      it "should be succesfull" do
        pending
        Product.stub(:find).and_return(products)
        get 'glitter'
        response.should be_success
      end
    end
  end

  describe "GET 'color_block'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        pending
        Product.should_receive(:find).and_return(products)
        get 'color_block'
        assigns(:products).should == products
      end

      it "should be succesfull" do
        pending
        Product.stub(:find).and_return(products)
        get 'color_block'
        response.should be_success
      end
    end
  end

  describe "GET 'golden_grace'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        pending
        Product.should_receive(:find).and_return(products)
        get 'golden_grace'
        assigns(:products).should == products
      end

      it "should be succesfull" do
        pending
        Product.stub(:find).and_return(products)
        get 'golden_grace'
        response.should be_success
      end
    end
  end

  describe "GET 'lets_party'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        Product.should_receive(:find).and_return(products)
        get 'lets_party'
        assigns(:products).should == products
      end

      it "should be succesfull" do
        Product.stub(:find).and_return(products)
        get 'lets_party'
        response.should be_success
      end
    end
  end

  describe "GET 'flores'" do
    context "without a logged user" do
      it "assigns @products to found products" do
        pending
        Product.should_receive(:find).and_return(products)
        get 'flores'
        assigns(:products).should == products
      end

      it "should be succesfull" do
        pending
        Product.stub(:find).and_return(products)
        get 'flores'
        response.should be_success
      end
    end
  end
end
