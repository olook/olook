  # -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Operations dashboard", %q{
  As any admin user
  I can view orders by their planned delivery statuses
  So I can better manage late deliveries
} do

	scenario "Listing the orders by their dates and statuses" do
		ApplicationController.any_instance.stub(:load_promotion)

		@admin = FactoryGirl.create(:admin_superadministrator)
	do_admin_login!(@admin)

	visit '/admin'

	page.should have_content "Dashboard"

	page.should have_content "Sumário dos pedidos"
  end

end