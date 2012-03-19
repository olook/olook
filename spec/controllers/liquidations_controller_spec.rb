require 'spec_helper'

describe LiquidationsController do
  with_a_logged_user do
    let(:liquidation) { FactoryGirl.create(:liquidation) }
    let(:order) { FactoryGirl.create(:order, :user => user).id }

    before :each do
      session[:order] = order
    end

    describe "GET 'show'" do
      it "returns http success" do
        get 'show', :id => liquidation
        response.should be_success
      end

      it "returns http success" do
        get 'show', :id => liquidation
        assigns(:order).should == Order.find(order)
      end

      it "assigns @liquidation" do
        get 'show', :id => liquidation.id
        assigns(:liquidation).should eql(liquidation)
      end

      it "searchs products" do
        params = {"id" => "#{liquidation.id}", "controller" => "liquidations", "action"=>"show"}
        LiquidationSearchService.should_receive(:new).with(params).and_return(liquidation_search_service = mock)
        liquidation_search_service.should_receive(:search_products)
        get :show, params
      end
    end

    describe "GET 'update'" do
      it "assigns @liquidation" do
        get :update, :format => :js,  :id => liquidation.id
        assigns(:liquidation).should eql(liquidation)
      end

      it "searchs products" do
        params = {"id" => "#{liquidation.id}", "controller" => "liquidations", "action"=>"show"}
        LiquidationSearchService.should_receive(:new).with(params).and_return(liquidation_search_service = mock)
        liquidation_search_service.should_receive(:search_products)
        get :show, params
      end
    end
  end
end
