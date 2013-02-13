# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::Orders::StatusesHelper do
	let(:options) { { total: 1, day_number: 1, state: 'delivered' } }
    let(:link) { "<a href=\"statuses/show?#{options.to_params}\">1</a>".gsub!("&", "&amp;") }

	# with_a_logged_admin do
	context "#orders_status_link" do
    before(:each) do
      f = FactoryGirl.create(:delivered_order, created_at: 1.business_days.ago)
      f.update_attribute(:updated_at, 1.business_days.ago)
    end

    it "returns a link to the orders details page" do
      expect(helper.orders_status_link(options)).to eq(link)
    end

    context "with freight_state param" do
    	let(:options) { { total: 1, day_number: 1, state: 'delivered', freight_state: 'SP' } }
    	
    	it "returns the same link with this param included" do
    		expect(helper.orders_status_link(options)).to eq(link)
    	end
    end

    context "with shipping_service params" do
    	let(:options) { { total: 1, day_number: 1, state: 'delivered', shipping_service_name: 'PAC' } }
    	
    	it "returns the same link with this param included" do
    		expect(helper.orders_status_link(options)).to eq(link)
    	end
    end

    context "with freight_state and shipping_service params" do
    	let(:options) { { total: 1, day_number: 1, state: 'delivered', freight_state: 'SP', shipping_service_name: 'PAC' } }
    	
    	it "returns the same link with these params included" do
    		expect(helper.orders_status_link(options)).to eq(link)
    	end
    end
	end
end
