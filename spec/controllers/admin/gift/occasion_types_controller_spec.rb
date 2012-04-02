require 'spec_helper'

describe Admin::Gift::OccasionTypesController do
  render_views
  let!(:occasion_type) { FactoryGirl.create(:gift_occasion_type) }
  let!(:valid_attributes) { occasion_type.attributes }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = Factory :admin_superadministrator
    sign_in @admin
  end

  describe "GET index" do
    it "assigns all occasion types as @gift_occasion_types" do
      get :index
      controller.should render_template("index")
      assigns(:gift_occasion_types).should eq([occasion_type])
    end
  end

  describe "GET show" do
    it "assigns the requested occasion type as @gift_occasion_type" do
      get :show, :id => occasion_type.id.to_s
      assigns(:gift_occasion_type).should eq(occasion_type)
    end
  end

  describe "GET new" do
    it "assigns a new occasion type as @gift_occasion_type" do
      get :new
      assigns(:gift_occasion_type).should be_a_new(GiftOccasionType)
    end
  end

  describe "GET edit" do
    it "assigns the requested occasion type as @gift_occasion_type" do
      get :edit, :id => occasion_type.id.to_s
      assigns(:gift_occasion_type).should eq(occasion_type)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new occasion type" do
        expect {
          post :create, :gift_occasion_type => valid_attributes
        }.to change(GiftOccasionType, :count).by(1)
      end

      it "assigns a newly created occasion type as @gift_occasion_type" do
        post :create, :gift_occasion_type => valid_attributes
        assigns(:gift_occasion_type).should be_a(GiftOccasionType)
        assigns(:gift_occasion_type).should be_persisted
      end

      it "redirects to the created occasion type" do
        post :create, :gift_occasion_type => valid_attributes
        response.should redirect_to(admin_gift_occasion_type_path(GiftOccasionType.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved occasion type as @gift_occasion_type" do
        GiftOccasionType.any_instance.stub(:save).and_return(false)
        post :create, :gift_occasion_type => {}
        assigns(:gift_occasion_type).should be_a_new(GiftOccasionType)
      end

      it "re-renders the 'new' template" do
        GiftOccasionType.any_instance.stub(:save).and_return(false)
        post :create, :gift_occasion_type => {}
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested occasion type" do
        GiftOccasionType.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => occasion_type.id, :gift_occasion_type => {'these' => 'params'}
      end

      it "assigns the requested occasion type as @gift_occasion_type" do
        put :update, :id => occasion_type.id, :gift_occasion_type => valid_attributes
        assigns(:gift_occasion_type).should eq(occasion_type)
      end
      
      it "redirects to the occasion type" do
        put :update, :id => occasion_type.id, :gift_occasion_type => valid_attributes
        response.should redirect_to(admin_gift_occasion_type_path(occasion_type))
      end
    end

    describe "with invalid params" do
      it "assigns the occasion type as @gift_occasion_type" do
        GiftOccasionType.any_instance.stub(:save).and_return(false)
        put :update, :id => occasion_type.id.to_s, :gift_occasion_type => {}
        assigns(:gift_occasion_type).should eq(occasion_type)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        GiftOccasionType.any_instance.stub(:save).and_return(false)
        put :update, :id => occasion_type.id.to_s, :gift_occasion_type => {}
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested occasion type" do
      expect {
        delete :destroy, :id => occasion_type.id.to_s
      }.to change(GiftOccasionType, :count).by(-1)
    end

    it "redirects to the occasion types list" do
      delete :destroy, :id => occasion_type.id.to_s
      response.should redirect_to(admin_gift_occasion_types_url)
    end
  end
end
