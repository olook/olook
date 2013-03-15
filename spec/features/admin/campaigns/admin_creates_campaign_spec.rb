# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Admin creates a campaign" do

  before :each do
  	@admin = FactoryGirl.create(:admin_superadministrator)
    @collection = FactoryGirl.create(:inactive_collection)
    Collection.stub_chain(:active, :id)
    do_admin_login!(@admin)
  end

  let!(:banner_page) { FactoryGirl.create(:page)}

  scenario "with valid attributes" do
    visit "/admin"
    click_link "Campaigns"
    click_link "New campaign"
    expect(page).to have_content('New Campaign')
    fill_in "campaign_title", with: "Nova Campanha"
    click_on("Criar Campaign")
    expect(page).to have_content('Nova Campanha')
    expect(page).to have_content('Campaign was successfully created.')
  end

  scenario "with banner page and without banner image" do
    visit "/admin"
    click_link "Campaigns"
    click_link "New campaign"
    fill_in "campaign_title", with: "Nova Campanha"
    first(:checkbox).set(:true)
    click_on("Criar Campaign")
    expect(page).to have_content('Banner Campo obrigatório')
  end

  scenario "with banner page and banner image" do
    visit "/admin"
    click_link "Campaigns"
    click_link "New campaign"
    fill_in "campaign_title", with: "Nova Campanha"
    attach_file('campaign_banner', "#{Rails.root}/spec/fixtures/valid_image.jpg")
    first(:checkbox).set(:true)
    click_on("Criar Campaign")
    expect(page).to have_content('Nova Campanha')
    expect(page).to have_content('Campaign was successfully created.')
  end

end
