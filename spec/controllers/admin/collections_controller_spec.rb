# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::CollectionsController do
  render_views

  let!(:collection) { FactoryGirl.create(:collection) }
  let!(:valid_attributes) { collection.attributes }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = Factory :admin
    sign_in @admin
  end

  describe "GET index" do
    it "assigns all collections as @collections" do
      get :index
      assigns(:collections).should eq([collection])
    end
  end

  describe "GET show" do
    it "assigns the requested collection as @collection" do
      get :show, :id => collection.id.to_s
      assigns(:collection).should eq(collection)
    end
  end

  describe "GET new" do
    it "assigns a new collection as @collection" do
      get :new
      assigns(:collection).should be_a_new(Collection)
    end
  end

  describe "GET edit" do
    it "assigns the requested collection as @collection" do
      get :edit, :id => collection.id.to_s
      assigns(:collection).should eq(collection)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Collection" do
        expect {
          post :create, :collection => valid_attributes
        }.to change(Collection, :count).by(1)
      end

      it "assigns a newly created collection as @collection" do
        post :create, :collection => valid_attributes
        assigns(:collection).should be_a(Collection)
        assigns(:collection).should be_persisted
      end

      it "redirects to the created collection" do
        post :create, :collection => valid_attributes
        response.should redirect_to(admin_collection_path(Collection.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved collection as @collection" do
        # Trigger the behavior that occurs when invalid params are submitted
        Collection.any_instance.stub(:save).and_return(false)
        post :create, :collection => {}
        assigns(:collection).should be_a_new(Collection)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Collection.any_instance.stub(:save).and_return(false)
        post :create, :collection => {}
        #response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested collection" do
        # Assuming there are no other collections in the database, this
        # specifies that the Collection created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Collection.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => collection.id, :collection => {'these' => 'params'}
      end

      it "assigns the requested collection as @collection" do
        put :update, :id => collection.id, :collection => valid_attributes
        assigns(:collection).should eq(collection)
      end
      
      it "redirects to the collection" do
        put :update, :id => collection.id, :collection => valid_attributes
        response.should redirect_to(admin_collection_path(collection))
      end
    end

    describe "with invalid params" do
      it "assigns the collection as @collection" do
        # Trigger the behavior that occurs when invalid params are submitted
        Collection.any_instance.stub(:save).and_return(false)
        put :update, :id => collection.id.to_s, :collection => {}
        assigns(:collection).should eq(collection)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Collection.any_instance.stub(:save).and_return(false)
        put :update, :id => collection.id.to_s, :collection => {}
        #response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested collection" do
      expect {
        delete :destroy, :id => collection.id.to_s
      }.to change(Collection, :count).by(-1)
    end

    it "redirects to the collections list" do
      delete :destroy, :id => collection.id.to_s
      response.should redirect_to(admin_collections_url)
    end
  end
end
