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
    [:index, :new, :show, :edit, :update, :create, :destroy].each { |a| p = Permission.create(model_name: 'CollectionTheme', action_name: a); p.roles << @admin.role }
  end

  scenario "As a business1 user I should be able to create a CollectionTheme" do
    do_admin_login!(@admin)
    visit '/admin'
    click_link 'Coleções temáticas'
    click_link 'Nova Coleção Temática'
    fill_in 'collection_theme_collection_theme_group_attributes_name', with: 'Grupo TESTE'
    fill_in 'collection_theme_name', with: 'Coleção Teste'
    fill_in 'collection_theme_slug', with: 'colecao-teste'
    check 'collection_theme_active'
    attach_file 'collection_theme_header_image', File.join(fixture_path, 'collection_theme_header_image.jpg')
    click_button 'Criar Coleção temática'
    page.should have_content('Tema: Coleção Teste')
  end

end
