require 'spec_helper'

describe Admin::LookbooksController do
	render_views
  let!(:product)      { FactoryGirl.create(:basic_shoe) }
  let!(:lookbook)      { FactoryGirl.create(:basic_lookbook, 
                        :product_list => { "#{product.id}" => "1" }, 
                        :product_criteo => { "#{product.id}" => "1" } ) }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = Factory :admin
    sign_in @admin
  end

  describe "GET index" do
    let(:searched_lookbook) { FactoryGirl.create(:complex_lookbook) }
    let(:search_param) { {"name_contains" => searched_lookbook.name} }

    it "should search for a lookbook using the search parameter" do
      get :index, :search => search_param

      assigns(:lookbooks).should_not include(lookbook)
      assigns(:lookbooks).should include(searched_lookbook)
    end
  end

  describe "GET edit" do
    it "assigns the requested lookbook as @lookbook" do
      get :edit, :id => lookbook.id.to_s
      assigns(:lookbook).should eq(lookbook)
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested lookbook" do
        Lookbook.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => lookbook.id, :lookbook => {'these' => 'params'}
      end

      it "assigns the requested lookbook as @lookbook" do
        put :update, :id => lookbook.id, :lookbook => lookbook.attributes
        assigns(:lookbook).should eq(lookbook)
      end

      it "redirects to the lookbook" do
        put :update, :id => lookbook.id, :lookbook => lookbook.attributes
        response.should redirect_to admin_lookbook_path
      end
    end
    describe "with invalid params" do
      it "assigns the lookbook as @lookbook" do
        Lookbook.any_instance.stub(:save).and_return(false)
        put :update, :id => lookbook.id.to_s, :lookbook => {}
        assigns(:lookbook).should eq(lookbook)
      end

      it "re-renders the 'edit' template" do
        Lookbook.any_instance.stub(:save).and_return(false)
        put :update, :id => lookbook.id.to_s, :lookbook => {}
        flash[:notice].should be_blank
      end
    end
  end

   describe "DELETE destroy" do
    it "destroys the requested lookbook" do
      expect {
        delete :destroy, :id => lookbook.id.to_s
      }.to change(Lookbook, :count).by(-1)
    end

    it "redirects to the lookbooks list" do
      delete :destroy, :id => lookbook.id.to_s
      response.should redirect_to(admin_lookbooks_url)
    end
  end

end
