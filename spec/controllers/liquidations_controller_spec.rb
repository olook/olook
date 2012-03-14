require 'spec_helper'

describe LiquidationsController do

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
