require 'spec_helper'


describe Admin::LandingPagesController do

  let!(:landing_page) { FactoryGirl.create :landing_page }

  let(:valid_attributes) { FactoryGirl.attributes_for :landing_page }

  describe "GET index" do
    it "assigns all landing_pages as @landing_pages" do
      get :index
      assigns(:landing_pages).should eq([landing_page])
    end
  end

  describe "GET show" do
    it "assigns the requested landing_page as @landing_page" do
      get :show, :id => landing_page.id.to_s
      assigns(:landing_page).should eq(landing_page)
    end
  end

  describe "GET new" do
    it "assigns a new landing_page as @landing_page" do
      get :new
      assigns(:landing_page).should be_a_new(LandingPage)
    end
  end

  describe "GET edit" do
    it "assigns the requested landing_page as @landing_page" do
      get :edit, :id => landing_page.id.to_s
      assigns(:landing_page).should eq(landing_page)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Admin::LandingPage" do
        expect {
          post :create, :landing_page => valid_attributes
        }.to change(LandingPage, :count).by(1)
      end

      it "assigns a newly created landing_page as @landing_page" do
        post :create, :landing_page => valid_attributes
        assigns(:landing_page).should be_a(LandingPage)
        assigns(:landing_page).should be_persisted
      end

      it "redirects to the created landing_page" do
        post :create, :landing_page => valid_attributes
        response.should redirect_to(admin_landing_page_path(LandingPage.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved landing_page as @landing_page" do
        # Trigger the behavior that occurs when invalid params are submitted
        LandingPage.any_instance.stub(:save).and_return(false)
        post :create, :landing_page => {}
        assigns(:landing_page).should be_a_new(LandingPage)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested landing_page" do
        LandingPage.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => landing_page.id, :landing_page => {'these' => 'params'}
      end

      it "assigns the requested landing_page as @landing_page" do
        put :update, :id => landing_page.id, :landing_page => valid_attributes
        assigns(:landing_page).should eq(landing_page)
      end

      it "redirects to the landing_page" do
        put :update, :id => landing_page.id, :landing_page => valid_attributes
        response.should redirect_to(admin_landing_page_path(landing_page))
      end
    end

    describe "with invalid params" do
      it "assigns the landing_page as @landing_page" do
        # Trigger the behavior that occurs when invalid params are submitted
        LandingPage.any_instance.stub(:save).and_return(false)
        put :update, :id => landing_page.id.to_s, :landing_page => {}
        assigns(:landing_page).should eq(landing_page)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested landing_page" do
      expect {
        delete :destroy, :id => landing_page.id.to_s
      }.to change(LandingPage, :count).by(-1)
    end

    it "redirects to the landing_pages list" do
      delete :destroy, :id => landing_page.id.to_s
      response.should redirect_to(admin_landing_pages_url)
    end
  end

end
