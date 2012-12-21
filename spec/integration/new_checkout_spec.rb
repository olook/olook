# -*- encoding : utf-8 -*-
=begin
require 'spec_helper'
require 'integration/helpers'

feature "Buying products using the new checkout", %q{
  As a user, I must be able to choose and buy a product
  using the new checkout flow
} do
  context "buying a product" do
    let(:user) { FactoryGirl.create(:user, cpf: "943.683.372-55") }
    let!(:user_info) { FactoryGirl.create(:user_info, user: user, shoes_size: nil) }
    let!(:bag) { FactoryGirl.create(:basic_bag) }
    let!(:bag_a) { FactoryGirl.create(:variant, product: bag, inventory: 10) }
    let!(:loyalty_program_credit_type) { FactoryGirl.create(:loyalty_program_credit_type, code: :loyalty_program) }
    let!(:invite_credit_type) { FactoryGirl.create(:invite_credit_type, code: :invite) }
    let!(:redeem_credit_type) { FactoryGirl.create(:redeem_credit_type, code: :redeem) }
    let!(:address) { FactoryGirl.create(:address, user: user) }

    context "purchase is successful" do
      pending
      background do
        Setting.stub(:checkout_suggested_product_id){nil}
        do_login!(user)
        visit product_path(bag)
        click_button "add_product"
        visit "sacola"
        click_link "Continuar"
        click_link "Usar este endereço"
      end

      context "billet purchase" do
        pending
        scenario "must have the billet printing link", js: true do
          pending
          click_link "Boleto Bancário"
          within("section.main") do
            find("input").click
          end
          save_and_open_page
        end
      end
    end
  end
end
=end
