 # -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Accessing my vitrine", "In order to see a customized list of products according to my profile" do
  include CarrierWave::Test::Matchers

  let!(:casual_profile) { FactoryGirl.create(:casual_profile, :with_products, :with_points, :with_user) }
  let(:user) { casual_profile.users.first }
  let(:products) { casual_profile.products }

  scenario "Viewing my product list" do
    do_login!(user) 
    visit member_showroom_path

    expect(page).to have_content('SEUS SAPATOS')
    expect(page).to have_content('SUAS BOLSAS')
    expect(page).to have_content('SEUS ACESSÓRIOS')

    # expect(page).to have_content(products.first.name)
  end

end
