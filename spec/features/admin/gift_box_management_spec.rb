require 'spec_helper'
require 'features/helpers'

feature "Admin user with business 1 role manages gift boxes", %q{
  As a business 1 I can create, edit and delete gift boxes
} do

  let(:gift_box) { FactoryGirl.create(:gift_box) }

  #TODO: figure out how to give the business1 role the correct permissions
  # to get the menu to render
  before :each do
  	@admin = FactoryGirl.create(:admin_superadministrator)
    @collection = FactoryGirl.create(:inactive_collection)
    Collection.stub_chain(:active, :id)
  end

  # Leaving js testing for later, same issues as with turnip (vcr/webmock conflicts)
  pending scenario "As a business1 user I should be allowed to see a list of gift boxes", :js => true do
  #scenario "As a business1 user I should be allowed to see a list of gift boxes" do
  	do_admin_login!(@admin)
    gift_box
    # save_and_open_page
    # page.find('li', text: "Gift Project").trigger(:mouseover)
    visit "/admin/gift_boxes"
    click_link "Gift boxes"
    page.should have_content "Listando Gift Boxes"
    page.should have_content "Nome"
    page.should have_content "Top 5"
    page.should have_content "Ativo"
    page.should have_content "Sim"
    page.should have_link "New Gift Box"
  end

  scenario "As a business1 user I should be denied to create a gift box if the form is not correct" do
  	do_admin_login!(@admin)
    visit "/admin/gift_boxes"
    click_link "New Gift Box"
    page.should have_content "Novo Gift Box Type"
    page.should have_content "Nome"
    page.should have_content "Ativo"
    click_button('Criar Gift box')
    page.should have_content "error prohibited this gift_box from being saved:"
  end

  scenario "As a business1 user I should be allowed to create a gift box if the form is correct" do
  	do_admin_login!(@admin)
    visit "/admin/gift_boxes"

    click_link "New Gift Box"
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
    click_button('Atualizar Gift box')
    page.should have_content "error prohibited this gift_box from being saved:"
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

  scenario "As a business1 user I should be allowed to destroy a gift box" do
  	do_admin_login!(@admin)
    gift_box
    visit "/admin/gift_boxes"
    page.should have_content "Listando Gift Boxes"
    page.should have_content "Nome"
    page.should have_content "Ativo"
    click_link "Deletar"
    page.should have_content "Gift Box Type deletada com sucesso."
  end
end

