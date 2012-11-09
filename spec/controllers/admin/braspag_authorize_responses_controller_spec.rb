# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::BraspagAuthorizeResponsesController do
  render_views
  let!(:clean_braspag_authorize_response) { FactoryGirl.create(:clean_braspag_authorize_response)}
  let!(:braspag_authorize_response) { FactoryGirl.create(:braspag_authorize_response)}
  let!(:payment) { FactoryGirl.create(:payment_braspag) }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin_superadministrator)
    sign_in @admin
  end

  describe "GET index" do
    let(:search_param) { {"order_id_eq" => braspag_authorize_response.order_id} }

    it "should find all braspag authorize responses using no parameter" do
      get :index
      assigns(:braspag_authorize_responses).should include(braspag_authorize_response)
      assigns(:braspag_authorize_responses).should include(clean_braspag_authorize_response)
    end

    it "should find only processed using the search parameter" do
      get :index, :search => search_param
      assigns(:responses).should eq([braspag_authorize_response])
    end
  end

  describe "GET show" do

    it "should assign the requested braspag_authorize_response as @braspag_authorize_responses" do
      get :show, :id => braspag_authorize_response.id.to_s
      assigns(:response).should eq(braspag_authorize_response)
      assigns(:payment).should eq(payment)
    end
  end
end
