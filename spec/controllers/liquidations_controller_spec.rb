require 'spec_helper'

describe LiquidationsController do

  describe "GET 'show'" do

    let(:basic_shoe_size_35) { FactoryGirl.create(:basic_shoe_size_35) }
    let(:basic_shoe_size_37) { FactoryGirl.create(:basic_shoe_size_37) }
    let(:basic_shoe_size_40) { FactoryGirl.create(:basic_shoe_size_40) }
    let(:liquidation) { FactoryGirl.create(:liquidation) }

    it "returns http success" do
      get 'show', :id => 1
      response.should be_success
    end

    context "isolated filters" do
      it "returns products given some subcategories" do
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteirinha")
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :subcategory_name => "melissa")
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :heel => 5.6)
        get :show, :id => 2, :subcategories => ["rasteirinha", "melissa"]
        assigns(:products).should == [basic_shoe_size_35.product, basic_shoe_size_40.product]
      end

      it "returns products given some shoe sizes" do
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :shoe_size => 45)
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :shoe_size => 35)
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :heel => 5.6)
        get :show, :id => 2, :shoe_sizes => ["45", "35"]
        assigns(:products).should == [basic_shoe_size_35.product, basic_shoe_size_40.product]
      end

      it "returns products given some heels" do
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :heel => 4.5)
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :heel => 6.5)
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :subcategory_name => "melissa")
        get :show, :id => 2, :heels => ["6.5", "4.5"]
        assigns(:products).should == [basic_shoe_size_35.product, basic_shoe_size_40.product]
      end
    end

    context "combined filters" do
      it "returns products given subcategories, shoe sizes and heels" do
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteirinha")
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :shoe_size => "45")
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :heel => 5.6)
        get :show, :id => 2, :subcategories => ["rasteirinha"], :shoe_sizes => ["45"], :heels => ["5.6"]
        assigns(:products).should == [basic_shoe_size_35.product, basic_shoe_size_40.product, basic_shoe_size_37.product]
      end

      it "returns products given subcategories and shoe sizes" do
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteirinha")
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :shoe_size => "45")
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :heel => 5.6)
        get :show, :id => 2, :subcategories => ["rasteirinha"], :shoe_sizes => ["45"]
        assigns(:products).should == [basic_shoe_size_35.product, basic_shoe_size_40.product]
      end

      it "returns products given subcategories and heels" do
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteirinha")
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :shoe_size => "45")
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :heel => 5.6)
        get :show, :id => 2, :subcategories => ["rasteirinha"], :heels => ["5.6"]
        assigns(:products).should == [basic_shoe_size_35.product, basic_shoe_size_37.product]
      end

      it "returns products given heels and shoe sizes" do
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteirinha")
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :shoe_size => "45")
        LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :heel => 5.6)
        get :show, :id => 2, :shoe_sizes => ["45"], :heels => ["5.6"]
        assigns(:products).should == [basic_shoe_size_40.product, basic_shoe_size_37.product]
      end
    end
  end
end
