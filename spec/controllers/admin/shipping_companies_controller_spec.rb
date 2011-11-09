# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::ShippingCompaniesController do
  render_views

  let!(:shipping_company) { FactoryGirl.create(:shipping_company) }
  let!(:valid_attributes) { shipping_company.attributes }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = Factory :admin
    sign_in @admin
  end

  describe "GET index" do
    it "assigns all shipping_companies as @shipping_companies" do
      get :index
      assigns(:shipping_companies).should eq([shipping_company])
    end
  end

  describe "GET show" do
    it "assigns the requested shipping_company as @shipping_company" do
      get :show, :id => shipping_company.id.to_s
      assigns(:shipping_company).should eq(shipping_company)
    end
  end

  describe "GET new" do
    it "assigns a new shipping_company as @shipping_company" do
      get :new
      assigns(:shipping_company).should be_a_new(ShippingCompany)
    end
  end

  describe "GET edit" do
    it "assigns the requested shipping_company as @shipping_company" do
      get :edit, :id => shipping_company.id.to_s
      assigns(:shipping_company).should eq(shipping_company)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ShippingCompany" do
        expect {
          post :create, :shipping_company => valid_attributes
        }.to change(ShippingCompany, :count).by(1)
      end

      it "assigns a newly created shipping_company as @shipping_company" do
        post :create, :shipping_company => valid_attributes
        assigns(:shipping_company).should be_a(ShippingCompany)
        assigns(:shipping_company).should be_persisted
      end

      it "redirects to the created shipping_company" do
        post :create, :shipping_company => valid_attributes
        response.should redirect_to(admin_shipping_company_path(ShippingCompany.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved shipping_company as @shipping_company" do
        # Trigger the behavior that occurs when invalid params are submitted
        ShippingCompany.any_instance.stub(:save).and_return(false)
        post :create, :shipping_company => {}
        assigns(:shipping_company).should be_a_new(ShippingCompany)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ShippingCompany.any_instance.stub(:save).and_return(false)
        post :create, :shipping_company => {}
        #response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested shipping_company" do
        # Assuming there are no other shipping_companies in the database, this
        # specifies that the ShippingCompany created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ShippingCompany.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => shipping_company.id, :shipping_company => {'these' => 'params'}
      end

      it "assigns the requested shipping_company as @shipping_company" do
        put :update, :id => shipping_company.id, :shipping_company => valid_attributes
        assigns(:shipping_company).should eq(shipping_company)
      end

      it "redirects to the shipping_company" do
        put :update, :id => shipping_company.id, :shipping_company => valid_attributes
        response.should redirect_to(admin_shipping_company_path(shipping_company))
      end
    end

    describe "with invalid params" do
      it "assigns the shipping_company as @shipping_company" do
        # Trigger the behavior that occurs when invalid params are submitted
        ShippingCompany.any_instance.stub(:save).and_return(false)
        put :update, :id => shipping_company.id.to_s, :shipping_company => {}
        assigns(:shipping_company).should eq(shipping_company)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ShippingCompany.any_instance.stub(:save).and_return(false)
        put :update, :id => shipping_company.id.to_s, :shipping_company => {}
        #response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested shipping_company" do
      expect {
        delete :destroy, :id => shipping_company.id.to_s
      }.to change(ShippingCompany, :count).by(-1)
    end

    it "redirects to the shipping_companies list" do
      delete :destroy, :id => shipping_company.id.to_s
      response.should redirect_to(admin_shipping_companies_url)
    end
  end

end
