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
	page.should have_content "Operações"

	page.should have_content "Prazo para despacho"
	page.should have_content "Pago"
	page.should have_content "Aguardando Separação"
	page.should have_content "Despachado"
	page.should have_content "Entregue"
	page.should have_content "Hoje"
	page.should have_content "Ontem"
	page.should have_content "2 dias atrás"
	page.should have_content "3 dias atrás"
	page.should have_content "4 dias atrás"
	page.should have_content "5 dias atrás"
	page.should have_content "6 ou mais dias atrás"
	page.should have_content "TOTAL"

  end

end
