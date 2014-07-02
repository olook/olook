  # -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Orders statuses dashboard", %q{
  As any admin user
  I can view orders by their statuses
  So I can better manage them
}, feature: true, admin: true do

  background do
    Delorean.time_travel_to("February 5, 2013")
    ApplicationController.any_instance.stub(:load_promotion)
    do_admin_login!(admin)
    visit '/admin'
  end

  let(:admin) { FactoryGirl.create(:admin_superadministrator) }
  let!(:order) { FactoryGirl.create(:authorized_order,
                         shipping_service_name: 'TEX',
                         freight_state: 'RJ') }
  let!(:order2) { FactoryGirl.create(:authorized_order,
                        shipping_service_name: 'PAC',
                        freight_state: 'SP') }

  scenario "Listing the orders by their dates and statuses" do

    click_link 'Status dos pedidos'

    expect(page).to have_content("Status do pedido")

    expect(page).to have_content("Prazo para despacho")
    expect(page).to have_content("Pago")
    expect(page).to have_content("Aguardando Separação")
    expect(page).to have_content("Despachado")
    expect(page).to have_content("Entregue")
    expect(page).to have_content("Terça")
    expect(page).to have_content("Segunda")
    expect(page).to have_content("Domingo")
    expect(page).to have_content("Sábado")
    expect(page).to have_content("Sexta")
    expect(page).to have_content("Quinta")
    expect(page).to have_content("Quarta")
    expect(page).to have_content("Terça")
    expect(page).to have_content("Segunda")
    expect(page).to have_content("Domingo")
    expect(page).to have_content("Sábado")
    expect(page).to have_content("TOTAL")

    expect(page.find('tr#0_dias td#total', text: '2'))

    expect(page).to have_css('#total_authorized', text: '2')
  end

  scenario 'Transportation filter' do

    click_link 'Status dos pedidos'

    expect(page.find('tr#0_dias td#authorized', text: '2'))

    select 'PAC', :from => "shipping_service_name"

    click_button 'Filtrar'

    expect(page.find('tr#0_dias td#authorized', text: '1'))

    page.find('tr#0_dias td#authorized a').click

    expect(page.first('tr td.shipping_service_name', text: 'PAC'))

    expect(page).to have_content('Filtrando por transportadora PAC')
  end

  scenario 'Freight state filter' do

    click_link 'Status dos pedidos'

    expect(page.find('tr#0_dias td#authorized', text: '2'))

    select 'SP', :from => "freight_state"

    click_button 'Filtrar'

    expect(page.find('tr#0_dias td#authorized', text: '1'))

    page.find('tr#0_dias td#authorized a').click

    expect(page.first('tr td.freight_state', text: 'SP'))

    expect(page).to have_content('Filtrando por SP')
  end

  scenario 'Both filters' do

    click_link 'Status dos pedidos'

    expect(page.find('tr#0_dias td#authorized', text: '2'))

    select 'RJ', :from => "freight_state"
    select 'TEX', :from => "shipping_service_name"

    click_button 'Filtrar'

    expect(page.find('tr#0_dias td#authorized', text: '1'))

    page.find('tr#0_dias td#authorized a').click

    expect(page.first('tr td.shipping_service_name', text: 'TEX'))
    expect(page.first('tr td.shipping_service_name', text: 'PAC'))

    expect(page.first('tr td.freight_state', text: 'RJ'))
    expect(page.first('tr td.freight_state', text: 'SP'))

    expect(page).to have_content('Filtrando por transportadora TEX e por RJ')
  end
end
