require 'spec_helper'

describe Admin::CollectionThemesController do
  render_views
  let!(:collection_theme_day) { FactoryGirl.create(:collection_theme) }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin_superadministrator)
    sign_in @admin
  end

  describe "GET index" do
    let(:collection_theme_party) { FactoryGirl.create(:collection_theme, :name => "festa", :slug => "festa") }
    let(:search_param) { {"name_contains" => collection_theme_party.name} }

    it "should search for a collection_theme using the search parameter" do
      get :index, :search => search_param

      assigns(:collection_themes).should_not include(collection_theme_day)
      assigns(:collection_themes).should include(collection_theme_party)
    end
  end

  describe "GET edit" do
    it "assigns the requested collection_theme as @collection_theme" do
      get :edit, :id => collection_theme_day.id.to_s
      assigns(:collection_theme).should eq(collection_theme_day)
    end
  end

  describe "PUT update" do
    describe "with valid params" do

      it "assigns the requested collection_theme as @collection_theme" do
        put :update, :id => collection_theme_day.id, :collection_theme => collection_theme_day.attributes
        assigns(:collection_theme).should eq(collection_theme_day)
      end

      it "redirects to the collection_theme" do
        put :update, :id => collection_theme_day.id, :collection_theme => collection_theme_day.attributes
        response.should redirect_to admin_collection_theme_path
      end
    end
    describe "with invalid params" do
      it "assigns the collection_theme as @collection_theme" do
        CollectionTheme.any_instance.stub(:save).and_return(false)
        put :update, :id => collection_theme_day.id.to_s, :collection_theme => {}
        assigns(:collection_theme).should eq(collection_theme_day)
      end

      it "re-renders the 'edit' template" do
        CollectionTheme.any_instance.stub(:save).and_return(false)
        put :update, :id => collection_theme_day.id.to_s, :collection_theme => {}
        flash[:notice].should be_blank
      end
    end
  end

   describe "DELETE destroy" do
    it "destroys the requested collection_theme" do
      expect {
        delete :destroy, :id => collection_theme_day.id.to_s
      }.to change(CollectionTheme, :count).by(-1)
    end

    it "redirects to the collection_themes list" do
      delete :destroy, :id => collection_theme_day.id.to_s
      response.should redirect_to(admin_collection_themes_url)
    end
  end

end
