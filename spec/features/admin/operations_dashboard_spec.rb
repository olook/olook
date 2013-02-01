  # -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Operations dashboard", %q{
  As any admin user
  I can view orders by their planned delivery statuses
  So I can better manage late deliveries
} do

  let(:admin) { FactoryGirl.create(:admin_superadministrator) }
  let!(:order) { FactoryGirl.create(:order,
                                     updated_at: Time.now,
                                     state: "authorized",
                                     shipping_service_name: 'TEX',
                                     freight_state: 'RJ') }

  background do
    ApplicationController.any_instance.stub(:load_promotion)
    do_admin_login!(admin)
    visit '/admin'
  end

  scenario "Listing the orders by their dates and statuses" do
    click_link 'Status dos pedidos'

    expect(page).to have_content("Status do pedido")

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

    expect(page.find('tr#0_dias td#total', text: '1'))

    expect(page).to have_css('#total_authorized', text: '1')
  end

  scenario "Viewing details for a list of orders" do
    click_link 'Status dos pedidos'

    page.find('tr#0_dias td#authorized a').click

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

  scenario 'Viewing delivery table' do
    4.times do |index|
      FactoryGirl.create(:delivered_order, expected_delivery_on: index.business_days.before(Time.now) )
    end

    3.times do |index|
      number = index + 1
      FactoryGirl.create(:delivered_order, expected_delivery_on: number.business_days.after(Time.now) )
    end

    click_link 'Pedidos referente entrega'

    expect(page).to have_content("<= -3")
    expect(page).to have_content("-2")
    expect(page).to have_content("-1")
    expect(page).to have_content("Data prometida")
    expect(page).to have_content("1")
    expect(page).to have_content("2")
    expect(page).to have_content(">= 3")

    # testa coluna de data de entrega prometida
    expect(page.find('tr#0_dias td#expected_delivery_on', text: '1'))
    expect(page.find('tr#1_dias td#expected_delivery_on', text: '1'))
    expect(page.find('tr#2_dias td#expected_delivery_on', text: '1'))
    expect(page.find('tr#3_dias td#expected_delivery_on', text: '1'))
    expect(page.find('tr#4_dias td#expected_delivery_on', text: '1'))
    expect(page.find('tr#5_dias td#expected_delivery_on', text: '1'))
    expect(page.find('tr#6_dias td#expected_delivery_on', text: '1'))
  end

  scenario 'Transportation filter' do
    FactoryGirl.create(:order,
                        updated_at: Time.now,
                        state: "authorized",
                        shipping_service_name: 'PAC',
                        freight_state: 'SP')

    click_link 'Status dos pedidos'

    expect(page.find('tr#0_dias td#authorized', text: '2'))

    select 'PAC', :from => "shipping_service_name"

    click_button 'Filtrar'

    save_and_open_page

    expect(page.find('tr#0_dias td#authorized', text: '1'))

    page.find('tr#0_dias td#authorized a').click

    expect(page.first('tr td.shipping_service_name', text: 'PAC'))
  end

  scenario 'Freight state filter' do
    FactoryGirl.create(:order,
                        updated_at: Time.now,
                        state: "authorized",
                        shipping_service_name: 'PAC',
                        freight_state: 'SP')

    click_link 'Status dos pedidos'

    expect(page.find('tr#0_dias td#authorized', text: '2'))

    select 'SP', :from => "freight_state"

    click_button 'Filtrar'

    expect(page.find('tr#0_dias td#authorized', text: '1'))

    page.find('tr#0_dias td#authorized a').click

    expect(page.first('tr td.freight_state', text: 'SP'))
  end

  scenario 'Both filters' do
    FactoryGirl.create(:order,
                        updated_at: Time.now,
                        state: "authorized",
                        shipping_service_name: 'PAC',
                        freight_state: 'SP')

    click_link 'Status dos pedidos'

    expect(page.find('tr#0_dias td#authorized', text: '2'))

    select 'RJ', :from => "freight_state"
    select 'TEX', :from => "shipping_service_name"

    click_button 'Filtrar'

    expect(page.find('tr#0_dias td#authorized', text: '1'))

    page.find('tr#0_dias td#authorized a').click

    expect(page.first('tr td.shipping_service_name', text: 'TEX'))

    expect(page.first('tr td.freight_state', text: 'RJ'))
  end

end
