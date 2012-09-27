# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::MoipCallbacksController do
  render_views
  let!(:moip_callback) { FactoryGirl.create(:moip_callback)}
  let!(:clean_moip_callback) { FactoryGirl.create(:clean_moip_callback)}

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin_superadministrator)
    sign_in @admin
  end

  describe "GET index" do
  	let (:search_param) { {"payment_id_eq" => moip_callback.payment_id} }

  	it "should find all moip callbacks using no parameter" do
  		get :index
  		assigns(:moip_callbacks).should include(moip_callback)
      assigns(:moip_callbacks).should include(clean_moip_callback)
  	end

  	it "should find only processed using the search parameter" do
  		get :index, :search => search_param
  		assigns(:moip_callbacks).should eq([moip_callback])
  	end
  end


end