# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::MoipCallbacksController, admin: true do
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

  describe "GET show" do

    it "should assign the requested moip_callback as @moip_callbacks" do
      get :show, :id => moip_callback.id.to_s
      assigns(:moip_callback).should eq(moip_callback)
      assigns(:payment).should eq(moip_callback.payment)
    end
  end

  describe "POST change_to_processed" do
    let(:processed_moip_callback) {FactoryGirl.create(:processed_moip_callback)}
    let(:not_processed_moip_callback) {FactoryGirl.create(:not_processed_moip_callback)}

    it "should update moip callback to processed when it's not processed" do
      post :change_to_processed, :id => not_processed_moip_callback.id
      not_processed_moip_callback.reload.processed.should eq(true)
      flash[:notice].should eq('O moip callback foi marcado como processado com sucesso.')
    end

    it "should display error message when cannot save moip_callback" do
      MoipCallback.any_instance.stub(:save).and_return(false)
      post :change_to_processed, :id => not_processed_moip_callback.id
      flash[:error].should eq('Nao foi possivel atualizar o moip callback como processado.')
    end

    it "should display error message when moip_callback is already processed" do
      post :change_to_processed, :id => processed_moip_callback.id
      flash[:error].should eq('O moip callback ja foi processado')
    end
  end

  describe "POST change_to_not_processed" do
    let(:processed_moip_callback) {FactoryGirl.create(:processed_moip_callback)}
    let(:not_processed_moip_callback) {FactoryGirl.create(:not_processed_moip_callback)}

    it "should update moip callback to not processed when it's processed" do
      post :change_to_not_processed, :id => processed_moip_callback.id
      processed_moip_callback.reload.processed.should eq(false)
      flash[:notice].should eq('O moip callback foi marcado como nao processado, e sera reprocessado em breve.')
    end

    it "should display error message when cannot save moip_callback" do
      MoipCallback.any_instance.stub(:save).and_return(false)
      post :change_to_not_processed, :id => processed_moip_callback.id
      flash[:error].should eq('Nao foi possivel atualizar o moip callback como nao processado.')
    end

    it "should display error message when moip_callback is already not processed" do
      post :change_to_not_processed, :id => not_processed_moip_callback.id
      flash[:error].should eq('O moip callback ainda nao foi processado')
    end
  end

end
