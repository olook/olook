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

  scenario 'Viewing delivery table' do

    4.times do |index|
      FactoryGirl.create(:delivered_order, expected_delivery_on: index.business_days.before(Time.now) )
    end

    3.times do |index|
      number = index + 1
      FactoryGirl.create(:delivered_order, expected_delivery_on: number.business_days.after(Time.now) )
    end

    click_link 'Status de entrega dos pedidos'

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

  scenario "Viewing details for a list of paid orders" do
    pending
    click_link 'Status dos pedidos'

    expect(page.find('tr#0_dias td#delivering', text: '1'))

    page.find('tr#0_dias td#delivering a').click

    # expect(page).to have_content(
  end

end
