# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::PaymentsController do
  render_views
  let!(:credit) { FactoryGirl.create(:credit)}
  let!(:credit_card) { FactoryGirl.create(:credit_card, :credit_ids => credit.id)}
  let!(:debit) { FactoryGirl.create(:debit)}

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin_superadministrator)
    sign_in @admin
  end

  describe "GET index" do
    let (:search_param) { {"user_name_eq" => credit_card.user_name} }

  	it "should find all moip callbacks using no parameter" do
      get :index
      assigns(:payments).should include(credit_card)
      assigns(:payments).should include(debit)
  	end

  	it "should find only processed using the search parameter" do
      get :index, :search => search_param
      assigns(:payments).should eq([credit_card])
  	end
  end

  describe "GET show" do

    it "should assign the requested payment as @payment" do
      get :show, :id => credit_card.id.to_s
      assigns(:payment).should eq(credit_card)
      assigns(:credits).should include(credit)
    end
  end


end