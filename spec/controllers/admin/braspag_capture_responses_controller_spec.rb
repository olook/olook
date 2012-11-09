# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::BraspagCaptureResponsesController do
  render_views
  let!(:clean_braspag_capture_response) { FactoryGirl.create(:clean_braspag_capture_response)}
  let!(:braspag_capture_response) { FactoryGirl.create(:braspag_capture_response)}
  let!(:payment) { FactoryGirl.create(:payment_braspag) }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin_superadministrator)
    sign_in @admin
  end

  describe "GET index" do
    let(:search_param) { {"order_id_eq" => braspag_capture_response.order_id} }

    it "should find all braspag capture responses using no parameter" do
      get :index
      assigns(:braspag_capture_responses).should include(braspag_capture_response)
      assigns(:braspag_capture_responses).should include(clean_braspag_capture_response)
    end

    it "should find only processed using the search parameter" do
      get :index, :search => search_param
      assigns(:responses).should eq([braspag_capture_response])
    end
  end

  describe "GET show" do

    it "should assign the requested braspag_capture_response as @braspag_capture_responses" do
      get :show, :id => braspag_capture_response.id.to_s
      assigns(:response).should eq(braspag_capture_response)
      assigns(:payment).should eq(payment)
    end
  end
end

