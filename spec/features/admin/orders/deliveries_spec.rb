  # -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Deliveries dashboard", %q{
  As any admin user
  I can view orders by their delivery dates
  So I can better manage late deliveries
} do

  background do
    Delorean.time_travel_to("February 5, 2013")
    ApplicationController.any_instance.stub(:load_promotion)
    do_admin_login!(admin)
    visit '/admin'
  end

  let(:admin) { FactoryGirl.create(:admin_superadministrator) }
  let!(:order) { FactoryGirl.create(:delivered_order,  
                                    expected_delivery_on: 2.business_days.after(Time.now),
                                    shipping_service_name: 'PAC',
                                    freight_state: 'RJ') }

  scenario 'Viewing delivery table' do

    4.times do |index|
      FactoryGirl.create(:delivered_order, expected_delivery_on: index.business_days.before(Time.now) )
    end

    3.times do |index|
      number = index + 1
      FactoryGirl.create(:delivered_order, expected_delivery_on: number.business_days.after(Time.now) )
    end

    click_link 'Entregas'

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
    expect(page.find('tr#5_dias td#expected_delivery_on', text: '2'))
    expect(page.find('tr#6_dias td#expected_delivery_on', text: '1'))
  end

  scenario "Viewing details for a list of paid orders" do

    click_link 'Entregas'

    expect(page.find('tr#5_dias td#expected_delivery_on', text: '1'))

    page.find('tr#5_dias td#expected_delivery_on a').click

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
    
    expect(page).to have_content("PAC")
    expect(page).to have_content("Rio de Janeiro")
    expect(page).to have_content("RJ")
    expect(page).to have_content("87656-908")
  end

  scenario 'Transportation filter' do
    FactoryGirl.create(:delivered_order, 
                        expected_delivery_on: 2.business_days.after(Time.now),
                        shipping_service_name: 'TEX')

    click_link 'Entregas'

    expect(page.find('tr#5_dias td#expected_delivery_on', text: '2'))

    select 'PAC', :from => "shipping_service_name"

    click_button 'Filtrar'

    expect(page.find('tr#5_dias td#expected_delivery_on', text: '1'))

    page.find('tr#5_dias td#expected_delivery_on a').click

    expect(page.first('tr td.shipping_service_name', text: 'PAC'))

    expect(page).to have_content('Filtrando por transportadora PAC')
  end

  scenario 'Freight state filter' do
    FactoryGirl.create(:delivered_order, 
                        expected_delivery_on: 2.business_days.after(Time.now),
                        freight_state: 'SP')

    click_link 'Entregas'

    expect(page.find('tr#5_dias td#expected_delivery_on', text: '2'))

    select 'SP', :from => "freight_state"

    click_button 'Filtrar'

    expect(page.find('tr#5_dias td#expected_delivery_on', text: '1'))

    page.find('tr#5_dias td#expected_delivery_on a').click

    expect(page.first('tr td.freight_state', text: 'SP'))

    expect(page).to have_content('Filtrando por SP')
  end

  scenario 'Both filters' do
    FactoryGirl.create(:delivered_order,
                        expected_delivery_on: 2.business_days.after(Time.now),
                        freight_state: 'SP',
                        shipping_service_name: 'TEX')

    click_link 'Entregas'

    expect(page.find('tr#5_dias td#expected_delivery_on', text: '2'))

    select 'SP', :from => "freight_state"
    select 'TEX', :from => "shipping_service_name"

    click_button 'Filtrar'

    expect(page.find('tr#5_dias td#expected_delivery_on', text: '1'))

    page.find('tr#5_dias td#expected_delivery_on a').click

    expect(page.first('tr td.shipping_service_name', text: 'TEX'))

    expect(page.first('tr td.freight_state', text: 'SP'))

    expect(page).to have_content('Filtrando por transportadora TEX e por SP')
  end

end
