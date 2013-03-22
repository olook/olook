# encoding: utf-8
require 'spec_helper'
require 'features/helpers'

feature "Admin user manages collection_themes", %q{
  In order to publish collections for my ecommerce clients
  As a business 1 admin user
  I want to manage Collection Themes
} do

  before :each do
    @admin = FactoryGirl.create(:admin_business1)
  end

  scenario "As a business1 user I should be able to create a CollectionTheme" do
    do_admin_login!(@admin)
    visit '/admin'
    click 'Coleções Temáticas'
    click 'Nova Coleção Temática'
    fill_in 'collection_theme_collection_theme_group_attributes_name', with: 'Grupo TESTE'
    fill_in 'collection_theme_name', with: 'Coleção Teste'
    click 'collection_theme_active'

    raise 'Finish this test!'
  end

end
