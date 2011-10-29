# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::VariantsController do
  render_views
  let!(:variant) { FactoryGirl.create(:basic_shoe_size_35) }
  let!(:product) { variant.product }
  let!(:valid_attributes) { variant.attributes }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = Factory :admin
    sign_in @admin
  end

  describe "GET show" do
    it "assigns the requested variant as @variant" do
      get :show, :id => variant.id.to_s, :product_id => product.id
      assigns(:variant).should eq(variant)
    end
  end

  describe "GET new" do
    it "assigns a new variant as @variant" do
      get :new, :product_id => product.id
      assigns(:variant).should be_a_new(Variant)
    end
  end

  describe "GET edit" do
    it "assigns the requested variant as @variant" do
      get :edit, :id => variant.id.to_s, :product_id => product.id
      assigns(:variant).should eq(variant)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Variant" do
        expect {
          post :create, :variant => valid_attributes, :product_id => product.id
        }.to change(Variant, :count).by(1)
      end

      it "assigns a newly created variant as @variant" do
        post :create, :variant => valid_attributes, :product_id => product.id
        assigns(:variant).should be_a(Variant)
        assigns(:variant).should be_persisted
      end

      it "redirects to the created variant" do
        post :create, :variant => valid_attributes, :product_id => product.id
        response.should redirect_to([:admin, Variant.last.product, Variant.last])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved variant as @variant" do
        # Trigger the behavior that occurs when invalid params are submitted
        Variant.any_instance.stub(:save).and_return(false)
        post :create, :variant => {}, :product_id => product.id
        assigns(:variant).should be_a_new(Variant)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Variant.any_instance.stub(:save).and_return(false)
        post :create, :variant => {}, :product_id => product.id
        flash[:notice].should be_blank
        #response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested variant" do
        # Assuming there are no other variants in the database, this
        # specifies that the Variant created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Variant.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => variant.id, :variant => {'these' => 'params'}, :product_id => product.id
      end

      it "assigns the requested variant as @variant" do
        put :update, :id => variant.id, :variant => valid_attributes, :product_id => product.id
        assigns(:variant).should eq(variant)
      end

      it "redirects to the variant" do
        put :update, :id => variant.id, :variant => valid_attributes, :product_id => product.id
        response.should redirect_to([:admin, product, variant])
      end
    end

    describe "with invalid params" do
      it "assigns the variant as @variant" do
        # Trigger the behavior that occurs when invalid params are submitted
        Variant.any_instance.stub(:save).and_return(false)
        put :update, :id => variant.id.to_s, :variant => {}, :product_id => product.id
        assigns(:variant).should eq(variant)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Variant.any_instance.stub(:save).and_return(false)
        put :update, :id => variant.id.to_s, :variant => {}, :product_id => product.id
        flash[:notice].should be_blank
        #response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested variant" do
      expect {
        delete :destroy, :id => variant.id.to_s, :product_id => product.id
      }.to change(Variant, :count).by(-1)
    end

    it "redirects to the variants list" do
      delete :destroy, :id => variant.id.to_s, :product_id => product.id
      response.should redirect_to([:admin, product])
    end
  end
end
