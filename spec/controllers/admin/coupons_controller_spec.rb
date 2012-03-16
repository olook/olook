require 'spec_helper'

describe Admin::CouponsController do
  render_views
  let!(:standard_coupon) { FactoryGirl.create(:standard_coupon) }
  let!(:expired_coupon) { FactoryGirl.create(:expired_coupon) }
  let!(:unlimited_coupon) { FactoryGirl.create(:unlimited_coupon) }
  let!(:limited_coupon) { FactoryGirl.create(:limited_coupon) }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = Factory :admin_superadministrator
    sign_in @admin
  end

  describe "GET index" do
    let(:searched_coupon) { FactoryGirl.create(:standard_coupon, :code => 'ZYX') }
    let(:search_param) { {"code_contains" => searched_coupon.code} }

    it "should search for a coupon using the search parameter" do
      get :index, :search => search_param

      assigns(:coupons).should_not include(standard_coupon)
      assigns(:coupons).should include(searched_coupon)
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      get :edit, :id => standard_coupon.id.to_s
      assigns(:coupon).should eq(standard_coupon)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested coupon" do
        Coupon.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => standard_coupon.id, :coupon => {'these' => 'params'}
      end

      it "assigns the requested coupon as @coupon" do
        put :update, :id => standard_coupon.id, :coupon => standard_coupon.attributes
        assigns(:coupon).should eq(standard_coupon)
      end

      it "redirects to the coupon" do
        put :update, :id => standard_coupon.id, :coupon => standard_coupon.attributes
        response.should redirect_to admin_coupons_path
      end
    end
    describe "with invalid params" do
      it "assigns the coupon as @coupon" do
        Coupon.any_instance.stub(:save).and_return(false)
        put :update, :id => standard_coupon.id.to_s, :coupon => {}
        assigns(:coupon).should eq(standard_coupon)
      end

      it "re-renders the 'edit' template" do
        Coupon.any_instance.stub(:save).and_return(false)
        put :update, :id => standard_coupon.id.to_s, :coupon => {}
        flash[:notice].should be_blank
      end
    end
  end
end
