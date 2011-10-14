# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::PicturesController do
  let!(:picture) { FactoryGirl.create(:gallery_picture) }
  let!(:product) { picture.product }
  let!(:valid_attributes) { picture.attributes }

  describe "GET show" do
    it "assigns the requested picture as @picture" do
      get :show, :id => picture.id.to_s, :product_id => product.id
      assigns(:picture).should eq(picture)
    end
  end

  describe "GET new" do
    it "assigns a new picture as @picture" do
      get :new, :product_id => product.id
      assigns(:picture).should be_a_new(Picture)
    end
  end

  describe "GET edit" do
    it "assigns the requested picture as @picture" do
      get :edit, :id => picture.id.to_s, :product_id => product.id
      assigns(:picture).should eq(picture)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Picture" do
        expect {
          post :create, :picture => valid_attributes, :product_id => product.id 
        }.to change(Picture, :count).by(1)
      end

      it "assigns a newly created picture as @picture" do
        post :create, :picture => valid_attributes, :product_id => product.id
        assigns(:picture).should be_a(Picture)
        assigns(:picture).should be_persisted
      end

      it "redirects to the created picture" do
        post :create, :picture => valid_attributes, :product_id => product.id
        response.should redirect_to([:admin, Picture.last.product, Picture.last])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved picture as @picture" do
        # Trigger the behavior that occurs when invalid params are submitted
        Picture.any_instance.stub(:save).and_return(false)
        post :create, :picture => {}, :product_id => product.id
        assigns(:picture).should be_a_new(Picture)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Picture.any_instance.stub(:save).and_return(false)
        post :create, :picture => {}, :product_id => product.id
        flash[:notice].should be_blank
        #response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested picture" do
        # Assuming there are no other pictures in the database, this
        # specifies that the Picture created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Picture.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => picture.id, :picture => {'these' => 'params'}, :product_id => product.id
      end

      it "assigns the requested picture as @picture" do
        put :update, :id => picture.id, :picture => valid_attributes, :product_id => product.id
        assigns(:picture).should eq(picture)
      end

      it "redirects to the picture" do
        put :update, :id => picture.id, :picture => valid_attributes, :product_id => product.id
        response.should redirect_to([:admin, product, picture])
      end
    end

    describe "with invalid params" do
      it "assigns the picture as @picture" do
        # Trigger the behavior that occurs when invalid params are submitted
        Picture.any_instance.stub(:save).and_return(false)
        put :update, :id => picture.id.to_s, :picture => {}, :product_id => product.id
        assigns(:picture).should eq(picture)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Picture.any_instance.stub(:save).and_return(false)
        put :update, :id => picture.id.to_s, :picture => {}, :product_id => product.id
        flash[:notice].should be_blank
        #response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested picture" do
      expect {
        delete :destroy, :id => picture.id.to_s, :product_id => product.id
      }.to change(Picture, :count).by(-1)
    end

    it "redirects to the pictures list" do
      delete :destroy, :id => picture.id.to_s, :product_id => product.id
      response.should redirect_to([:admin, product])
    end
  end

end
