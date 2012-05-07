require 'spec_helper'

describe Admin::MomentsController do
  render_views
  let!(:moment_day)      { FactoryGirl.create(:moment) }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = Factory :admin_superadministrator
    sign_in @admin
  end

  describe "GET index" do
    let(:moment_party) { FactoryGirl.create(:moment, :name => "festa", :slug => "festa") }
    let(:search_param) { {"name_contains" => moment_party.name} }

    it "should search for a moment using the search parameter" do
      get :index, :search => search_param

      assigns(:moments).should_not include(moment_day)
      assigns(:moments).should include(moment_party)
    end
  end

  describe "GET edit" do
    it "assigns the requested moment as @moment" do
      get :edit, :id => moment_day.id.to_s
      assigns(:moment).should eq(moment_day)
    end
  end

  describe "PUT update" do
    describe "with valid params" do

      it "assigns the requested moment as @moment" do
        put :update, :id => moment_day.id, :moment => moment_day.attributes
        assigns(:moment).should eq(moment_day)
      end

      it "redirects to the moment" do
        put :update, :id => moment_day.id, :moment => moment_day.attributes
        response.should redirect_to admin_moment_path
      end
    end
    describe "with invalid params" do
      it "assigns the moment as @moment" do
        Moment.any_instance.stub(:save).and_return(false)
        put :update, :id => moment_day.id.to_s, :moment => {}
        assigns(:moment).should eq(moment_day)
      end

      it "re-renders the 'edit' template" do
        Moment.any_instance.stub(:save).and_return(false)
        put :update, :id => moment_day.id.to_s, :moment => {}
        flash[:notice].should be_blank
      end
    end
  end

   describe "DELETE destroy" do
    it "destroys the requested moment" do
      expect {
        delete :destroy, :id => moment_day.id.to_s
      }.to change(Moment, :count).by(-1)
    end

    it "redirects to the moments list" do
      delete :destroy, :id => moment_day.id.to_s
      response.should redirect_to(admin_moments_url)
    end
  end

end
