require 'spec_helper'

describe Admin::CampaignsController do

  render_views

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin_superadministrator)
    sign_in @admin
  end

  let!(:campaign) { FactoryGirl.create(:campaign) }
  let!(:second_campaign) { FactoryGirl.create(:second_campaign) }
  describe "GET index" do
  	let (:search_param) { {"title_contains" => campaign.title} }

  	it "should find all campaigns using no parameter" do
  		get :index
  		assigns(:campaigns).should include(campaign)
      assigns(:campaigns).should include(second_campaign)
  	end

  	it "should find only one campaign using the search parameter" do
  		get :index, :search => search_param
  		assigns(:campaigns).should eq([campaign])
  	end
  end

  describe "GET 'new'" do
    it "assigns a new campaign as @campaign" do
      get :new
      assigns(:campaign).should be_a_new(Campaign)
    end
  end

  describe "GET 'show'" do
    it "assigns the requested campaign as @campaign" do
      get :show, :id => campaign.id.to_s
      assigns(:campaign).should eq(campaign)
    end
  end

  describe "GET 'edit'" do
    it "assigns the requested Campaign as @campaign" do
      get :edit, :id => campaign.id.to_s
      assigns(:campaign).should eq(campaign)
    end
  end

end
