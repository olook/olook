# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::DashboardHelper do
	let(:order) { { day_number: 1, state: 'delivered' } }

	# with_a_logged_admin do
	context "#report_days_link" do
      context "past" do

        before(:each) do
          f = FactoryGirl.create(:delivered_order, created_at: 1.business_days.ago)
          f.update_attribute(:updated_at, 1.business_days.ago)
        end

        it "returns a link with orders from a past date" do
          options = { day_number: 1, state: 'delivered' }

          link = '<a href="/admin/report_detail?day_number=1&amp;state=delivered">1</a>'
          expect(helper.report_days_link(options)).to eq(link)
        end

      end

	end

	context "#report_deliver_link" do
		context "past" do
			before(:each) do
				f = FactoryGirl.create(:delivered_order, expected_delivery_on: 2.business_days.ago)
				f2 = FactoryGirl.create(:delivered_order, expected_delivery_on: 6.business_days.ago)
			end

			it "should return a link with orders from a past date" do
				link = '<a href="/admin/report_detail?number=1&amp;state=delivered">1</a>'
				expect(helper.report_deliver_link(1, state: "delivered")).to eq(link)
			end
		end

		context "present and future" do
			before(:each) do
				f = FactoryGirl.create(:delivered_order, expected_delivery_on: 2.business_days.from_now)
				f2 = FactoryGirl.create(:delivered_order, expected_delivery_on: 4.business_days.from_now)
			end

			it "should return a link with orders expected on a future date" do
				link = '<a href="/admin/report_detail?number=5&amp;state=delivered">1</a>'
				expect(helper.report_deliver_link(5, state: "delivered")).to eq(link)
			end
		end
	end
	# end
end
