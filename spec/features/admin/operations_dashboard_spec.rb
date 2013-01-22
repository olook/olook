  # -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Operations dashboard", %q{
  As any admin user
  I can view orders by their planned delivery statuses
  So I can better manage late deliveries
} do

  let(:admin) { FactoryGirl.create(:admin_superadministrator) }

  background do
    ApplicationController.any_instance.stub(:load_promotion)
    FactoryGirl.create(:order, created_at: Time.now, state: "authorized")
    do_admin_login!(admin)
    visit '/admin'
  end

	scenario "Listing the orders by their dates and statuses" do
    expect(page).to have_content("Dashboard")
    expect(page).to have_content("Operações")

    expect(page).to have_content("Prazo para despacho")
    expect(page).to have_content("Pago")
    expect(page).to have_content("Aguardando Separação")
    expect(page).to have_content("Despachado")
    expect(page).to have_content("Entregue")
    expect(page).to have_content("Hoje")
    expect(page).to have_content("Ontem")
    expect(page).to have_content("2 dias atrás")
    expect(page).to have_content("3 dias atrás")
    expect(page).to have_content("4 dias atrás")
    expect(page).to have_content("5 dias atrás")
    expect(page).to have_content("6 ou mais dias atrás")
    expect(page).to have_content("TOTAL")

    expect(page).to have_css('#total_authorized', text: '1')
  end

  scenario "Viewing details for a list of orders" do
    save_and_open_page
    within('tr#0_dias') do
      find('td.authorized a').first.click
    end
  end

end
