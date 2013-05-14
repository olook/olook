# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::BraspagCaptureResponsesController, admin: true do
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
    let(:search_param) { {"identification_code_eq" => braspag_capture_response.identification_code} }

    it "should find all braspag capture responses using no parameter" do
      get :index
      assigns(:responses).should include(braspag_capture_response)
      assigns(:responses).should include(clean_braspag_capture_response)
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

  describe "POST change_to_processed" do
    let(:processed_braspag_capture_response) {FactoryGirl.create(:processed_braspag_capture_response)}
    let(:not_processed_braspag_capture_response) {FactoryGirl.create(:not_processed_braspag_capture_response)}

    it "should update moip callback to processed when it's not processed" do
      post :change_to_processed, :id => not_processed_braspag_capture_response.id
      not_processed_braspag_capture_response.reload.processed.should eq(true)
      flash[:notice].should eq('A capture response foi marcada como processada com sucesso.')
    end

    it "should display error message when cannot save moip_callback" do
      BraspagCaptureResponse.any_instance.stub(:save).and_return(false)
      post :change_to_processed, :id => not_processed_braspag_capture_response.id
      flash[:error].should eq('Nao foi possivel atualizar o capture response como processada.')
    end

    it "should display error message when moip_callback is already processed" do
      post :change_to_processed, :id => processed_braspag_capture_response.id
      flash[:error].should eq('A capture response ja foi processada.')
    end
  end

  describe "POST change_to_not_processed" do
    let(:processed_braspag_capture_response) {FactoryGirl.create(:processed_braspag_capture_response)}
    let(:not_processed_braspag_capture_response) {FactoryGirl.create(:not_processed_braspag_capture_response)}

    it "should update moip callback to not processed when it's processed" do
      post :change_to_not_processed, :id => processed_braspag_capture_response.id
      processed_braspag_capture_response.reload.processed.should eq(false)
      flash[:notice].should eq('A capture response foi marcada como nao processada, e sera reprocessada em breve.')
    end

    it "should display error message when cannot save moip_callback" do
      BraspagCaptureResponse.any_instance.stub(:save).and_return(false)
      post :change_to_not_processed, :id => processed_braspag_capture_response.id
      flash[:error].should eq('Nao foi possivel atualizar o capture response como nao processada.')
    end

    it "should display error message when moip_callback is already not processed" do
      post :change_to_not_processed, :id => not_processed_braspag_capture_response.id
      flash[:error].should eq('A capture response ainda nao foi processada.')
    end
  end
end
