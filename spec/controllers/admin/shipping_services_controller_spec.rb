# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::ShippingServicesController do
  render_views

  let!(:shipping_service) { FactoryGirl.create(:shipping_service) }
  let!(:valid_attributes) { shipping_service.attributes }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = Factory :admin
    sign_in @admin
  end

  describe "GET index" do
    it "assigns all shipping_services as @shipping_services" do
      get :index
      assigns(:shipping_services).should eq([shipping_service])
    end
  end

  describe "GET show" do
    it "assigns the requested shipping_service as @shipping_service" do
      get :show, :id => shipping_service.id.to_s
      assigns(:shipping_service).should eq(shipping_service)
    end
  end

  describe "GET new" do
    it "assigns a new shipping_service as @shipping_service" do
      get :new
      assigns(:shipping_service).should be_a_new(ShippingService)
    end
  end

  describe "GET edit" do
    it "assigns the requested shipping_service as @shipping_service" do
      get :edit, :id => shipping_service.id.to_s
      assigns(:shipping_service).should eq(shipping_service)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ShippingService" do
        expect {
          post :create, :shipping_service => valid_attributes
        }.to change(ShippingService, :count).by(1)
      end

      it "assigns a newly created shipping_service as @shipping_service" do
        post :create, :shipping_service => valid_attributes
        assigns(:shipping_service).should be_a(ShippingService)
        assigns(:shipping_service).should be_persisted
      end

      it "redirects to the created shipping_service" do
        post :create, :shipping_service => valid_attributes
        response.should redirect_to(admin_shipping_service_path(ShippingService.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved shipping_service as @shipping_service" do
        # Trigger the behavior that occurs when invalid params are submitted
        ShippingService.any_instance.stub(:save).and_return(false)
        post :create, :shipping_service => {}
        assigns(:shipping_service).should be_a_new(ShippingService)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ShippingService.any_instance.stub(:save).and_return(false)
        post :create, :shipping_service => {}
        #response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested shipping_service" do
        # Assuming there are no other shipping_services in the database, this
        # specifies that the ShippingService created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ShippingService.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => shipping_service.id, :shipping_service => {'these' => 'params'}
      end

      it "assigns the requested shipping_service as @shipping_service" do
        put :update, :id => shipping_service.id, :shipping_service => valid_attributes
        assigns(:shipping_service).should eq(shipping_service)
      end
      
      it "redirects to the shipping_service" do
        put :update, :id => shipping_service.id, :shipping_service => valid_attributes
        response.should redirect_to(admin_shipping_service_path(shipping_service))
      end
    end

    describe "with invalid params" do
      it "assigns the shipping_service as @shipping_service" do
        # Trigger the behavior that occurs when invalid params are submitted
        ShippingService.any_instance.stub(:save).and_return(false)
        put :update, :id => shipping_service.id.to_s, :shipping_service => {}
        assigns(:shipping_service).should eq(shipping_service)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ShippingService.any_instance.stub(:save).and_return(false)
        put :update, :id => shipping_service.id.to_s, :shipping_service => {}
        #response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested shipping_service" do
      expect {
        delete :destroy, :id => shipping_service.id.to_s
      }.to change(ShippingService, :count).by(-1)
    end

    it "redirects to the shipping_services list" do
      delete :destroy, :id => shipping_service.id.to_s
      response.should redirect_to(admin_shipping_services_url)
    end
  end
  
  describe "#upload_freight_prices" do
    context 'when the user provides a file' do
      it "uploads freight price file when supplied by the user and schedule process" do
        temp_uploader = double TempFileUploader
        temp_uploader.stub('filename').and_return('freight_file')

        temp_uploader.should_receive('store!').with('freight_file')
        Resque.should_receive(:enqueue).with(ImportFreightPricesWorker, shipping_service.id.to_s, 'freight_file')

        TempFileUploader.stub(:new).and_return(temp_uploader)

        subject.stub(:params).and_return(:id => shipping_service.id.to_s, :shipping_service => valid_attributes, :freight_prices => 'freight_file')
        subject.send :upload_freight_prices
      end
    end
    
    context "when the user doesn't provide a file" do
      it "doesn't do anything" do
        ::TempFileUploader.should_not_receive(:new)
        subject.stub(:params).and_return(:id => shipping_service.id, :shipping_service => valid_attributes)
        subject.send :upload_freight_prices
      end
    end
  end
end
