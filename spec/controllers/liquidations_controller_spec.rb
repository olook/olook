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
  end

  describe "GET 'update'" do
    context "assigning variables" do
      it "assigns @liquidation" do
        get :update, :format => :js,  :id => liquidation.id
        assigns(:liquidation).should eql(liquidation)
      end
    end
  end
end
