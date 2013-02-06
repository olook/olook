  # -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Operations dashboard", %q{
  As any admin user
  I can view orders by their planned delivery statuses
  So I can better manage late deliveries
} do

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

  scenario "Viewing details for a list of authorized orders" do
    click_link 'Status dos pedidos'

    page.find('tr#0_dias td#authorized a').click

    save_and_open_page

    expect(page).to have_content("Cadastro")
    expect(page).to have_content("Pagamento")
    expect(page).to have_content("Despacho Entrega")
    expect(page).to have_content("Data prometida de Entrega")
    expect(page).to have_content("Transportador")
    expect(page).to have_content("Gateway de pagamento")
    expect(page).to have_content("Cliente nome")
    expect(page).to have_content("Cliente email")
    expect(page).to have_content("Cidade")
    expect(page).to have_content("Estado")
    expect(page).to have_content("CEP")
    expect(page).to have_content("Quantidade de itens")

    expect(page).to have_content(order.created_at.strftime('%A, %e %B %Y'))
    expect(page).to have_content(order.payments.for_erp.first.created_at.strftime('%A, %e %B %Y'))
    #TODO: Despacho Entrega
    #TODO: Data prometida de Entrega
    expect(page).to have_content("TEX")
    #TODO: Gateway de pagamento
    expect(page).to have_content("José Ernesto")
    expect(page).to have_content("jose.ernesto@dominio.com")
    expect(page).to have_content("Rio de Janeiro")
    expect(page).to have_content("RJ")
    expect(page).to have_content("87656-908")
    expect(page).to have_content("100.0")
    expect(page).to have_content("0")
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
