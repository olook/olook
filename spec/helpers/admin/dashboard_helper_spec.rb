# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::DashboardHelper do
	let(:options) { { total: 1, day_number: 1, state: 'delivered' } }

	# with_a_logged_admin do
	context "#orders_status_link" do
      context "past" do

        before(:each) do
          f = FactoryGirl.create(:delivered_order, created_at: 1.business_days.ago)
          f.update_attribute(:updated_at, 1.business_days.ago)
        end

        it "returns a link with orders from a past date" do
          link = '<a href="/admin/report_detail?day_number=1&amp;state=delivered&amp;total=1">1</a>'
          expect(helper.orders_status_link(options)).to eq(link)
        end

      end

	end

	context "#orders_delivery_link" do
		let(:options) { { total: 1, day_number: 1, state: 'delivered', action: 'orders_time_report' } }

		context "past" do
			before(:each) do
				f = FactoryGirl.create(:delivered_order, expected_delivery_on: 2.business_days.ago)
				f2 = FactoryGirl.create(:delivered_order, expected_delivery_on: 6.business_days.ago)
			end

			it "returns a link with orders from a past date" do
				link = '<a href="/admin/report_detail?action=orders_time_report&amp;day_number=1&amp;state=delivered&amp;total=1">1</a>'
				expect(helper.orders_delivery_link(options)).to eq(link)
			end
		end

		context "present and future" do
			before(:each) do
				f = FactoryGirl.create(:delivered_order, expected_delivery_on: 2.business_days.from_now)
				f2 = FactoryGirl.create(:delivered_order, expected_delivery_on: 4.business_days.from_now)
			end

			it "returns a link with orders expected on a future date" do
				link = '<a href="/admin/report_detail?action=orders_time_report&amp;day_number=5&amp;state=delivered&amp;total=1">1</a>'
				expect(helper.orders_delivery_link(options.merge!(day_number: 5))).to eq(link)
			end
		end
	end
	# end
end
