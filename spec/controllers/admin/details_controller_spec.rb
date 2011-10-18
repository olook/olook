# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::DetailsController do
  render_views
  let!(:detail) { FactoryGirl.create(:heel_detail) }
  let!(:product) { detail.product }
  let!(:valid_attributes) { detail.attributes }

  describe "GET show" do
    it "assigns the requested detail as @detail" do
      get :show, :id => detail.id.to_s, :product_id => product.id
      assigns(:detail).should eq(detail)
    end
  end

  describe "GET new" do
    it "assigns a new detail as @detail" do
      get :new, :product_id => product.id
      assigns(:detail).should be_a_new(Detail)
    end
  end

  describe "GET edit" do
    it "assigns the requested detail as @detail" do
      get :edit, :id => detail.id.to_s, :product_id => product.id
      assigns(:detail).should eq(detail)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Detail" do
        expect {
          post :create, :detail => valid_attributes, :product_id => product.id 
        }.to change(Detail, :count).by(1)
      end

      it "assigns a newly created detail as @detail" do
        post :create, :detail => valid_attributes, :product_id => product.id
        assigns(:detail).should be_a(Detail)
        assigns(:detail).should be_persisted
      end

      it "redirects to the created detail" do
        post :create, :detail => valid_attributes, :product_id => product.id
        response.should redirect_to([:admin, Detail.last.product, Detail.last])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved detail as @detail" do
        # Trigger the behavior that occurs when invalid params are submitted
        Detail.any_instance.stub(:save).and_return(false)
        post :create, :detail => {}, :product_id => product.id
        assigns(:detail).should be_a_new(Detail)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Detail.any_instance.stub(:save).and_return(false)
        post :create, :detail => {}, :product_id => product.id
        flash[:notice].should be_blank
        #response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested detail" do
        # Assuming there are no other details in the database, this
        # specifies that the Detail created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Detail.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => detail.id, :detail => {'these' => 'params'}, :product_id => product.id
      end

      it "assigns the requested detail as @detail" do
        put :update, :id => detail.id, :detail => valid_attributes, :product_id => product.id
        assigns(:detail).should eq(detail)
      end

      it "redirects to the detail" do
        put :update, :id => detail.id, :detail => valid_attributes, :product_id => product.id
        response.should redirect_to([:admin, product, detail])
      end
    end

    describe "with invalid params" do
      it "assigns the detail as @detail" do
        # Trigger the behavior that occurs when invalid params are submitted
        Detail.any_instance.stub(:save).and_return(false)
        put :update, :id => detail.id.to_s, :detail => {}, :product_id => product.id
        assigns(:detail).should eq(detail)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Detail.any_instance.stub(:save).and_return(false)
        put :update, :id => detail.id.to_s, :detail => {}, :product_id => product.id
        flash[:notice].should be_blank
        #response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested detail" do
      expect {
        delete :destroy, :id => detail.id.to_s, :product_id => product.id
      }.to change(Detail, :count).by(-1)
    end

    it "redirects to the details list" do
      delete :destroy, :id => detail.id.to_s, :product_id => product.id
      response.should redirect_to([:admin, product])
    end
  end

end
