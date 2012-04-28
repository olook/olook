# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::GiftRecipientRelationsController do
  render_views
  let!(:relation) { FactoryGirl.create(:gift_recipient_relation) }
  let!(:valid_attributes) { relation.attributes }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = Factory :admin_superadministrator
    sign_in @admin
  end

  describe "GET index" do
    it "assigns all relations as @gift_recipient_relations" do
      get :index
      controller.should render_template("index")
      assigns(:gift_recipient_relations).should eq([relation])
    end
  end

  describe "GET show" do
    it "assigns the requested relation as @gift_recipient_relation" do
      get :show, :id => relation.id.to_s
      assigns(:gift_recipient_relation).should eq(relation)
    end
  end

  describe "GET new" do
    it "assigns a new relation as @gift_recipient_relation" do
      get :new
      assigns(:gift_recipient_relation).should be_a_new(GiftRecipientRelation)
    end
  end

  describe "GET edit" do
    it "assigns the requested relation as @gift_recipient_relation" do
      get :edit, :id => relation.id.to_s
      assigns(:gift_recipient_relation).should eq(relation)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new relation" do
        expect {
          post :create, :gift_recipient_relation => valid_attributes
        }.to change(GiftRecipientRelation, :count).by(1)
      end

      it "assigns a newly created relation as @gift_recipient_relation" do
        post :create, :gift_recipient_relation => valid_attributes
        assigns(:gift_recipient_relation).should be_a(GiftRecipientRelation)
        assigns(:gift_recipient_relation).should be_persisted
      end

      it "redirects to the created relation" do
        post :create, :gift_recipient_relation => valid_attributes
        response.should redirect_to(admin_gift_recipient_relation_path(GiftRecipientRelation.unscoped.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved relation as @gift_recipient_relation" do
        GiftRecipientRelation.any_instance.stub(:save).and_return(false)
        post :create, :gift_recipient_relation => {}
        assigns(:gift_recipient_relation).should be_a_new(GiftRecipientRelation)
      end

      it "re-renders the 'new' template" do
        GiftRecipientRelation.any_instance.stub(:save).and_return(false)
        post :create, :gift_recipient_relation => {}
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested relation" do
        GiftRecipientRelation.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => relation.id, :gift_recipient_relation => {'these' => 'params'}
      end

      it "assigns the requested relation as @gift_recipient_relation" do
        put :update, :id => relation.id, :gift_recipient_relation => valid_attributes
        assigns(:gift_recipient_relation).should eq(relation)
      end
      
      it "redirects to the relation" do
        put :update, :id => relation.id, :gift_recipient_relation => valid_attributes
        response.should redirect_to(admin_gift_recipient_relation_path(relation))
      end
    end

    describe "with invalid params" do
      it "assigns the relation as @relation" do
        GiftRecipientRelation.any_instance.stub(:save).and_return(false)
        put :update, :id => relation.id.to_s, :gift_recipient_relation => {}
        assigns(:gift_recipient_relation).should eq(relation)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        GiftRecipientRelation.any_instance.stub(:save).and_return(false)
        put :update, :id => relation.id.to_s, :gift_recipient_relation => {}
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested relation" do
      expect {
        delete :destroy, :id => relation.id.to_s
      }.to change(GiftRecipientRelation, :count).by(-1)
    end

    it "redirects to the relations list" do
      delete :destroy, :id => relation.id.to_s
      response.should redirect_to(admin_gift_recipient_relations_url)
    end
  end
end
