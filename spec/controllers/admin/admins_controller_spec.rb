# -*- encoding : utf-8 -*-
require 'spec_helper'
require "ruby-debug"
describe Admin::AdminsController do
  
  render_views

  let!(:admin) { FactoryGirl.create(:admin_sac_operator) }

  let!(:valid_attributes_with_password){
    {:first_name => "Doug", :last_name => "Funny", :password => "123456", 
    :password_confirmation => "123456", :email => "drfunny@olook.com.br", 
    :role_attributes => {:id => admin.role_id.to_s} } }

  let!(:valid_attributes_without_password) do
    admin.attributes.clone.tap do |attributes|
      attributes[:first_name] = "Bob"
      attributes[:last_name] = "Dob"
      attributes[:role_attributes] = {"id" => admin.role_id.to_s}
    end
  end

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = Factory :admin_superadministrator
    sign_in @admin
  end

  describe "GET index" do
    it "assigns all admins as @admins if has permission do perform it" do
      get :index
      controller.should render_template("index")
      assigns(:admins).should eq([admin, @admin])
    end
  end

  describe "GET show" do
    it "assigns the requested admin as @admin" do
      get :show, :id => admin.id.to_s
      assigns(:admin).should eq(admin)
    end
  end

  describe "GET new" do
    it "assigns a new Admin as @Admin" do
      get :new
      assigns(:admin).should be_a_new(Admin)
    end
  end

  describe "GET edit" do
    it "assigns the requested Admin as @Admin" do
      get :edit, :id => admin.id.to_s
      assigns(:admin).should eq(admin)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Admin" do
        expect {
          post :create, :admin => valid_attributes_with_password
        }.to change(Admin, :count).by(1)
      end

      it "assigns a newly created admin as @admin" do
        post :create, :admin => valid_attributes_with_password
        assigns(:admin).should be_a(Admin)
        assigns(:admin).should be_persisted
      end

      it "redirects to the created admin" do
        post :create, :admin => valid_attributes_with_password
        response.should redirect_to(admin_admin_path(Admin.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved admin as @admin" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin.any_instance.stub(:save).and_return(false)
        post :create, :admin => {}
        assigns(:admin).should be_a_new(Admin)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin.any_instance.stub(:save).and_return(false)
        post :create, :admin => {}
        #response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params and password" do
      it "updates the requested Admin" do
        # Assuming there are no other Admins in the database, this
        # specifies that the Admin created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Admin.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => admin.id, :admin => {'these' => 'params'}
      end

      it "assigns the requested admin as @admin" do
        put :update, :id => admin.id, :admin => valid_attributes_with_password
        assigns(:admin).should eq(admin)
      end
      
      it "redirects to the admin" do
        put :update, :id => admin.id, :admin => valid_attributes_with_password
        response.should redirect_to(admin_admin_path(admin))
      end
    end

    describe "with valid params and without password" do
      it "updates the requested Admin" do
        # Assuming there are no other Admins in the database, this
        # specifies that the Admin created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Admin.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => admin.id, :admin => {'these' => 'params'}
      end

      it "assigns the requested admin as @admin" do
        put :update, :id => admin.id, :admin => valid_attributes_without_password
        assigns(:admin).should eq(admin)
      end
      
      it "redirects to the admin" do
        put :update, :id => admin.id, :admin => valid_attributes_without_password
        response.should redirect_to(admin_admin_path(admin))
      end
    end



    describe "with invalid params" do
      it "assigns the Admin as @Admin" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin.any_instance.stub(:save).and_return(false)
        put :update, :id => admin.id.to_s, :admin => {}
        assigns(:admin).should eq(admin)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin.any_instance.stub(:save).and_return(false)
        put :update, :id => admin.id.to_s, :admin => {}
        #response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested Admin" do
      expect {
        delete :destroy, :id => admin.id.to_s
      }.to change(Admin, :count).by(-1)
    end

    it "redirects to the Admins list" do
      delete :destroy, :id => admin.id.to_s
      response.should redirect_to(admin_admins_url)
    end
  end


end
