require 'spec_helper'
require 'integration/helpers'

feature "Admin user with business 1 role manages gift boxes", %q{
  As a business 1 I can create, edit and delete gift boxes
} do

  let(:gift_box) { FactoryGirl.create(:gift_box) }

  before :each do
  	@admin = FactoryGirl.create(:admin_business1)
    @collection = FactoryGirl.create(:inactive_collection)
    Collection.stub_chain(:active, :id)
  end

  scenario "As a business1 user I should be allowed to see a list of gift boxes" do
  	do_admin_login!(@admin)
    visit "/admin/gift_boxes"
    page.should have_content "Listando Gift Boxes Types"
    page.should have_content "Nome"
    page.should have_content "Ativo"
  end

  scenario "As a business1 user I should be denied to create a gift box if the form is not correct" do
  	do_admin_login!(@admin)
    visit "/admin/gift_boxes/new"
    page.should have_content "Novo Gift Box Type"
    page.should have_content "Nome"
    page.should have_content "Ativo"
    click_button('Criar Gift box')
    page.should have_content "errors prohibited this landing page from being saved:"
  end

  scenario "As a business1 user I should be allowed to create a gift box if the form is correct" do
  	do_admin_login!(@admin)
    visit "/admin/gift_boxes/new"
    page.should have_content "Novo Gift Box Type"
    page.should have_content "Nome"
    page.should have_content "Ativo"
    fill_in 'gift_box[name]', :with => 'Gift Box Test'
    check('gift_box[active]')
    click_button('Criar Gift box')
    page.should have_content "Gift Box Type criada com sucesso."
  end

  scenario "As a business1 user I should be denied to update a gift box if the form is not correct" do
  	do_admin_login!(@admin)
    visit "/admin/gift_boxes/#{ gift_box.id }/edit"
    page.should have_content "Editar Gift Box Type"
    page.should have_content "Nome"
    page.should have_content "Ativo"
    fill_in 'gift_box[name]', :with => ""
    uncheck('gift_box[active]')
    click_button('Atualizar Gift box')
    page.should have_content "errors prohibited this landing page from being saved:"
  end

  scenario "As a business1 user I should be allowed to update a gift box if the form is correct" do
  	do_admin_login!(@admin)
    visit "/admin/gift_boxes/#{ gift_box.id }/edit"
    page.should have_content "Editar Gift Box Type"
    page.should have_content "Nome"
    page.should have_content "Ativo"
    fill_in 'gift_box[name]', :with => 'Gift Box Test Updated'
    check('gift_box[active]')
    click_button('Atualizar Gift box')
    page.should have_content "Gift Box Type atualizada com sucesso."
    page.should have_content "Gift Box Test Updated"
  end

end

