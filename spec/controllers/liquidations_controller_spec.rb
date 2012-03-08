require 'spec_helper'

describe LiquidationsController do

  let(:basic_shoe_size_35) { FactoryGirl.create(:basic_shoe_size_35) }
  let(:basic_shoe_size_37) { FactoryGirl.create(:basic_shoe_size_37) }
  let(:basic_shoe_size_40) { FactoryGirl.create(:basic_shoe_size_40) }

  let(:basic_bag) { FactoryGirl.create(:basic_bag) }
  let(:basic_accessory) { FactoryGirl.create(:basic_accessory) }

  let(:basic_bag_1) { FactoryGirl.create(:basic_bag_simple, :product => basic_bag) }
  let(:basic_accessory_1) { FactoryGirl.create(:basic_accessory_simple, :product => basic_accessory) }

  let(:liquidation) { FactoryGirl.create(:liquidation) }

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', :id => liquidation
      response.should be_success
    end

    it "assigns @liquidation" do
      get 'show', :id => liquidation.id
      assigns(:liquidation).should eql(liquidation)
    end
  end

  describe "GET 'update'" do

  context "assigning variables" do
    it "assigns @liquidation" do
      get :update, :format => :js,  :id => liquidation.id
      assigns(:liquidation).should eql(liquidation)
    end
  end
   context "isolated filters" do
      it "returns products given some subcategories" do
        lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteirinha")
        lp2 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :subcategory_name => "melissa")
        lp3 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :heel => 5.6)
        get :update, :format => :js,  :id => liquidation.id, :subcategories => ["rasteirinha", "melissa"]
        assigns(:liquidation_products).should == [lp1, lp2]
      end

      it "returns products given some shoe sizes" do
        lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :shoe_size => 45)
        lp2 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :shoe_size => 35)
        lp3 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :heel => 5.6)
        get :update, :format => :js, :id => liquidation.id, :shoe_sizes => ["45", "35"]
        assigns(:liquidation_products).should == [lp1, lp2]
      end

      it "returns products given some heels" do
        lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :heel => 4.5)
        lp2 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :heel => 6.5)
        lp3 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :subcategory_name => "melissa")
        get :update, :format => :js, :id => liquidation.id, :heels => ["6.5", "4.5"]
        assigns(:liquidation_products).should == [lp1, lp2]
      end
    end

    context "ordering" do
      it "should return the order: shoes, bags and acessories" do
        lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :heel => 4.5)
        lp2 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_accessory_1.product.id, :subcategory_name => "pulseira")
        lp3 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_bag_1.product.id, :subcategory_name => "lisa")
        get :update, :format => :js, :id => liquidation.id, :subcategories => ["pulseira", "lisa"], :heels => ["4.5"]
        assigns(:liquidation_products).should == [lp1, lp3, lp2]
      end
    end

    context "combined filters" do
      it "returns products given subcategories, shoe sizes and heels" do
        lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteirinha")
        lp2 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :shoe_size => "45")
        lp3 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :heel => 5.6)
        get :update, :format => :js, :id => liquidation.id, :subcategories => ["rasteirinha"], :shoe_sizes => ["45"], :heels => ["5.6"]
        assigns(:liquidation_products).should == [lp1, lp2, lp3]
      end

      it "returns products given subcategories and shoe sizes" do
        lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteirinha")
        lp2 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :shoe_size => "45")
        lp3 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :heel => 5.6)
        get :update, :format => :js, :id => liquidation.id, :subcategories => ["rasteirinha"], :shoe_sizes => ["45"]
        assigns(:liquidation_products).should == [lp1, lp2]
      end

      it "returns products given subcategories and heels" do
        lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteirinha")
        lp2 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :shoe_size => "45")
        lp3 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :heel => 5.6)
        get :update, :format => :js, :id => liquidation.id, :subcategories => ["rasteirinha"], :heels => ["5.6"]
        assigns(:liquidation_products).should == [lp1, lp3]
      end

      it "returns products given heels and shoe sizes" do
        lp1 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_35.product.id, :subcategory_name => "rasteirinha")
        lp2 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_40.product.id, :shoe_size => "45")
        lp3 = LiquidationProduct.create(:liquidation => liquidation, :product_id => basic_shoe_size_37.product.id, :heel => 5.6)
        get :update, :format => :js, :id => liquidation.id, :shoe_sizes => ["45"], :heels => ["5.6"]
        assigns(:liquidation_products).should == [lp2, lp3]
      end
    end
  end
end
