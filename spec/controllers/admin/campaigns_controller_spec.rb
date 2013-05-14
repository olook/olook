require 'spec_helper'

describe Admin::CampaignsController, admin: true do

  render_views

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin_superadministrator)
    sign_in @admin
  end

  let!(:campaign) { FactoryGirl.create(:campaign) }
  describe "GET index" do
    let!(:second_campaign) { FactoryGirl.create(:second_campaign) }
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


  describe "POST create" do
    let!(:campaign) { FactoryGirl.build(:campaign) }
    context "with valid params" do
      it "creates a new Campaign" do
        expect {
          post :create, :campaign => campaign.attributes
        }.to change(Campaign, :count).by(1)
      end

      it "assigns a newly created campaign as @campaign" do
        post :create, :campaign => campaign.attributes
        assigns(:campaign).should be_a(Campaign)
        assigns(:campaign).should be_persisted
      end

      it "redirects to the created admin" do
        post :create, :campaign => campaign.attributes
        response.should redirect_to(admin_campaign_path(Campaign.last))
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved campaign as @campaign" do
        Campaign.any_instance.stub(:save).and_return(false)
        post :create, :campaign => {}
        assigns(:campaign).should be_a_new(Campaign)
      end

      it "re-renders the 'new' template" do
        Campaign.any_instance.stub(:save).and_return(false)
        post :create, :campaign => {}
      end
    end
  end
  describe "PUT update" do
    context "with valid params and password" do
      it "updates the requested Campaign" do
        Campaign.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => campaign.id, :campaign => {'these' => 'params'}
      end

      it "assigns the requested campaign as @campaign" do
        put :update, :id => campaign.id
        assigns(:campaign).should eq(campaign)
      end

      it "redirects to the campaign" do
        put :update, :id => campaign.id
        response.should redirect_to(admin_campaign_path(campaign))
      end
    end

    context "with invalid params" do
      it "assigns the Campaign as @Campaign" do
        Campaign.any_instance.stub(:save).and_return(false)
        put :update, :id => campaign.id.to_s, :campaign => {}
        assigns(:campaign).should eq(campaign)
      end

      it "re-renders the 'edit' template" do
        Campaign.any_instance.stub(:save).and_return(false)
        put :update, :id => campaign.id.to_s, :campaign => {}
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested Campaign" do
      expect {
        delete :destroy, :id => campaign.id.to_s
      }.to change(Campaign, :count).by(-1)
    end

    it "redirects to the Admins list" do
      delete :destroy, :id => campaign.id.to_s
      response.should redirect_to(admin_campaigns_url)
    end
  end

end
