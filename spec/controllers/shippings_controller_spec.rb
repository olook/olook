require 'spec_helper'

describe ShippingsController do

  describe "GET #SHOW" do

    context "when input a valid zip_code" do

      let(:delivery_time) {3}
      let(:inventory_delay) {FreightCalculator::DEFAULT_INVENTORY_TIME}

      before do
        FactoryGirl.create(:freight_price, :order_value_end => 100, :delivery_time => delivery_time)
        get :show, :id => "00000010", :format => :json
      end

      it { response.should be_ok }
      it { response.should render_template :show }

      it "sums delivery_time with inventory_delay" do
        assigns(:days_to_deliver).should == delivery_time + inventory_delay
      end

    end

    context "when input an invalid zip_code" do
      before { get :show, :id => "ASDFASD1092", :format => :json }
      it { response.should be_not_found }
    end

    context "when input an empty zip_code" do
      before { get :show, :id => "", :format => :json }
      it { response.should be_not_found }
    end

  end

end
