require 'spec_helper'

describe Admin::LiquidationProductsController do
  with_a_logged_admin do
    render_views

    before :all do
      Promotion.delete_all
    end
  let!(:liquidation)   { FactoryGirl.create(:liquidation) }
  let!(:liquidation_product)   { FactoryGirl.create(:liquidation_product) }
  
    describe "PUT update" do
      it "should update the liquidation product" do
        put :update, {:id => liquidation_product.id, :liquidation_id => liquidation.id, :liquidation_product => {:retail_price => 20}}
        response.should redirect_to(admin_liquidation_products_path(liquidation.id))
      end
    end
  end

end
