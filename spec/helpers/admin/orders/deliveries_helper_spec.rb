# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::Orders::DeliveriesHelper do
	let(:options) { { day_number: 1, state: 'delivered' } }
  let(:link) { "<a href=\"deliveries/show?#{options.to_params}\">1</a>".gsub!("&", "&amp;") }

	before(:each) do
		FactoryGirl.create(:delivered_order, expected_delivery_on: 2.business_days.ago)
	end

	context "#orders_delivery_link" do
		let(:options) { { day_number: 1, state: 'delivered' } }

		context "with past expected delivery date" do

			it "returns a link with orders from a past date" do
				expect(helper.orders_delivery_link(options)).to eq(link)
			end
		end

		context "present and future expected delivery date" do
			before(:each) do
				FactoryGirl.create(:delivered_order, expected_delivery_on: 2.business_days.from_now)
				FactoryGirl.create(:delivered_order, expected_delivery_on: 4.business_days.from_now)
			end

			it "returns a link with orders expected on a future date" do
				expect(helper.orders_delivery_link(options.merge!(day_number: 5))).to eq(link)
			end
		end

    context "with freight_state param" do
    	let(:options) { { day_number: 1, state: 'delivered', freight_state: 'SP' } }
    	
    	it "returns the same link with this param included" do
    		expect(helper.orders_delivery_link(options)).to eq(link)
    	end
    end

    context "with shipping_service params" do
    	let(:options) { { day_number: 1, state: 'delivered', shipping_service_name: 'PAC' } }
    	
    	it "returns the same link with this param included" do
    		expect(helper.orders_delivery_link(options)).to eq(link)
    	end
    end

    context "with freight_state and shipping_service params" do
    	let(:options) { { day_number: 1, state: 'delivered', freight_state: 'SP', shipping_service_name: 'PAC' } }
    	
    	it "returns the same link with these params included" do
    		expect(helper.orders_delivery_link(options)).to eq(link)
    	end
    end
	end
end
