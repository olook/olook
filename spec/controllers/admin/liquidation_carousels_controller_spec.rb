require 'spec_helper'

describe Admin::LiquidationCarouselsController do
  render_views
  let!(:product)   { FactoryGirl.create(:basic_shoe, :id => 10) }
  let!(:liquidation)   { FactoryGirl.create(:liquidation) }
  let!(:valid_attributes) { FactoryGirl.build(:liquidation_carousel, :product_id => product.id).attributes }
  let!(:invalid_attributes) { FactoryGirl.build(:liquidation_carousel, :product_id => 999999).attributes }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin)
    sign_in @admin
  end

  describe "GET index" do

    context "Verifing the before_filter actions" do
      before :each do
        get :index, :liquidation_id => liquidation.id
      end

      it "should get the current liquidation being acessed" do
        assigns(:liquidation).should == liquidation
      end

      it "should get a empty array element cause there is no image in carousel" do
        assigns(:liquidation_carousels).should be_empty
      end

      it "should define a new liquidation carousel" do
        assigns(:liquidation_carousel).should be_a(LiquidationCarousel)
      end

    end

  end

  describe "POST create" do
    context "with valid params" do
      before :each do
        post :create, :liquidation_id => liquidation.id, :liquidation_carousel => valid_attributes
      end

      it "creates a new liquidation carousel" do
        expect {
          post :create, :liquidation_id => liquidation.id, :liquidation_carousel => valid_attributes
        }.to change(LiquidationCarousel, :count).by(1)
      end

      it "should not created a liquidation carousel without a product id present in liquidation" do
        expect {
          post :create, :liquidation_id => liquidation.id, :liquidation_carousel => invalid_attributes
        }.to  change(LiquidationCarousel, :count).by(0)
      end

      it "assigns a newly created carousel as @carousel" do
        assigns(:carousel).should be_a(LiquidationCarousel)
      end

      it "redirects to the index" do
        response.should redirect_to(admin_liquidation_carousels_path(liquidation.id))
      end
    end
  end

  describe "PUT update" do
    let!(:liquidation_carousel) { FactoryGirl.create(:liquidation_carousel, :product_id => product.id) }

    it "should update the liquidation carousel" do
      put :update, :liquidation_id => liquidation.id, :liquidation_carousel => { :id => liquidation_carousel.id, :product_id => product.id }
      response.should redirect_to(admin_liquidation_carousels_path(liquidation.id))
    end
  end

  describe "DELETE destroy" do
    let!(:liquidation_carousel) { FactoryGirl.create(:liquidation_carousel, :product_id => product.id) }

    it "destroys the requested carousel liquidation" do
      expect {
        delete :destroy, :liquidation_id => liquidation.id, :id => liquidation_carousel.id
      }.to change(LiquidationCarousel, :count).by(-1)
    end

    it "redirects to the lookbooks list" do
      delete :destroy, :liquidation_id => liquidation.id, :id => liquidation_carousel.id
      response.should redirect_to(admin_liquidation_carousels_path(liquidation.id))
    end
  end

end
