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


  describe "POST create" do
    describe "with valid params" do
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

    describe "with invalid params" do
      it "assigns a newly created but unsaved campaign as @campaign" do
        # Trigger the behavior that occurs when invalid params are submitted
        Campaign.any_instance.stub(:save).and_return(false)
        post :create, :campaign => {}
        assigns(:campaign).should be_a_new(Campaign)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin.any_instance.stub(:save).and_return(false)
        post :create, :campaign => {}
        #response.should render_template("new")
      end
    end
  end
=begin

  describe "PUT update" do
    describe "with valid params and password" do
      it "updates the requested Admin" do
        # Assuming there are no other Admins in the database, this
        # specifies that the Admin created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Admin.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => admin.id, :admin => {'these' => 'params'}
      end

      it "assigns the requested admin as @admin" do
        put :update, :id => admin.id, :admin => valid_attributes_with_password
        assigns(:admin).should eq(admin)
      end

      it "redirects to the admin" do
        put :update, :id => admin.id, :admin => valid_attributes_with_password
        response.should redirect_to(admin_admin_path(admin))
      end
    end

    describe "with valid params and without password" do
      it "updates the requested Admin" do
        # Assuming there are no other Admins in the database, this
        # specifies that the Admin created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Admin.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => admin.id, :admin => {'these' => 'params'}
      end

      it "assigns the requested admin as @admin" do
        put :update, :id => admin.id, :admin => valid_attributes_without_password
        assigns(:admin).should eq(admin)
      end

      it "redirects to the admin" do
        put :update, :id => admin.id, :admin => valid_attributes_without_password
        response.should redirect_to(admin_admin_path(admin))
      end
    end



    describe "with invalid params" do
      it "assigns the Admin as @Admin" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin.any_instance.stub(:save).and_return(false)
        put :update, :id => admin.id.to_s, :admin => {}
        assigns(:admin).should eq(admin)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin.any_instance.stub(:save).and_return(false)
        put :update, :id => admin.id.to_s, :admin => {}
        #response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested Admin" do
      expect {
        delete :destroy, :id => admin.id.to_s
      }.to change(Admin, :count).by(-1)
    end

    it "redirects to the Admins list" do
      delete :destroy, :id => admin.id.to_s
      response.should redirect_to(admin_admins_url)
    end
  end
=end

end
