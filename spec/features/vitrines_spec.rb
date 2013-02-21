 # -*- encoding : utf-8 -*-
require 'spec_helper'
require 'features/helpers'

feature "Accessing my vitrine", "In order to see a customized list of products according to my profile" do
  include CarrierWave::Test::Matchers

  let(:casual_profile) { FactoryGirl.create(:casual_profile, :with_products, :with_points, :with_user) }
  let(:user) { casual_profile.users.first }
  let(:products) { casual_profile.products }

  before(:all) do
    user.update_attribute(:password, '123456')
    user.update_attribute(:password_confirmation, '123456')
  end

  scenario "Viewing my product list" do
    do_login!(user) 

    expect(page).to have_content('Seus sapatos')
    expect(page).to have_content('Suas bolsas')
    expect(page).to have_content('Seus acessórios')

    expect(page).to have_content(products.first.name)
  end

end
