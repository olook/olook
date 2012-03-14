require 'spec_helper'
describe Admin::LiquidationsController do
  render_views
  let!(:liquidation)   { FactoryGirl.create(:liquidation) }
  let!(:valid_attributes) { FactoryGirl.build(:liquidation).attributes }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = Factory :admin
    sign_in @admin
  end

  describe "GET index" do
    it "should get all liquidations" do
      get :index
      assigns(:liquidations).should eq([liquidation])
    end
  end

  describe "GET show" do
    it "assigns the requested liquidation as @liquidation" do
      get :show, {:id => liquidation.id}
      assigns(:liquidation).should eq(liquidation)
    end
  end

  describe "GET new" do
    it "assigns a new liquidation as @liquidation" do
      get :new
      assigns(:liquidation).should be_a_new(Liquidation)
    end
  end

  describe "GET edit" do
    it "assigns the requested liquidation as @liquidation" do
      get :edit, {:id => liquidation.id}
      assigns(:liquidation).should eq(liquidation)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Liquidation" do
        expect {
          post :create, {:liquidation => valid_attributes}
        }.to change(Liquidation, :count).by(1)
      end

      it "assigns a newly created liquidation as @liquidation" do
        post :create, {:liquidation => valid_attributes}
        assigns(:liquidation).should be_a(Liquidation)
        assigns(:liquidation).should be_persisted
      end

      it "redirects to the created liquidation" do
        post :create, {:liquidation => valid_attributes}
        response.should redirect_to(admin_liquidation_path(Liquidation.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved liquidation as @liquidation" do
        Liquidation.any_instance.stub(:save).and_return(false)
        post :create, {:liquidation => {}}
        assigns(:liquidation).should be_a_new(Liquidation)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do

      it "assigns the requested liquidation as @liquidation" do
        put :update, {:id => liquidation.to_param, :liquidation => valid_attributes}
        assigns(:liquidation).should eq(liquidation)
      end

      it "redirects to the liquidation" do
        put :update, {:id => liquidation.to_param, :liquidation => valid_attributes}
        response.should redirect_to(admin_liquidation_path(Liquidation.last))
      end
    end

    describe "with invalid params" do
      it "assigns the liquidation as @liquidation" do
        Liquidation.any_instance.stub(:save).and_return(false)
        put :update, {:id => liquidation.to_param, :liquidation => {}}
        assigns(:liquidation).should eq(liquidation)
      end

    end
  end

  describe "DELETE destroy" do
    it "destroys the requested liquidation" do
      expect {
        delete :destroy, {:id => liquidation.to_param}
      }.to change(Liquidation, :count).by(-1)
    end

    it "redirects to the admin_liquidations list" do
      delete :destroy, {:id => liquidation.to_param}
      response.should redirect_to(admin_liquidations_url)
    end
  end
end
