require 'spec_helper'

describe ShippingsController do

  describe "GET #SHOW" do

    context "when input a valid zip_code" do

      let(:delivery_time) {3}
      let(:inventory_delay) {FreightCalculator::DEFAULT_INVENTORY_TIME}

      before do
        get :show, :id => "00000010", :format => :json
      end

      it { response.should be_ok }
      it { response.should render_template :show }
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
