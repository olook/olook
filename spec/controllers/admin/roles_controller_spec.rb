# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin::RolesController do
  
  render_views

  let!(:role) { FactoryGirl.create(:sac_operator) }

  let(:valid_attributes) do
    role.attributes.clone.tap do |attributes|
      attributes[:name] = "superadmin" 
    end
  end

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin_superadministrator)
    sign_in @admin
  end

  describe "GET index" do
    it "assigns all roles as @roles" do
      get :index
      controller.should render_template("index")
      assigns(:roles).should eq([role,@admin.role])
    end
  end

  describe "GET show" do
    it "assigns the requested role as @role" do
      get :show, :id => role.id.to_s
      assigns(:role).should eq(role)
    end
  end

  describe "GET new" do
    it "assigns a new role as @role" do
      get :new
      assigns(:role).should be_a_new(Role)
    end
  end

  describe "GET edit" do
    it "assigns the requested role as @role" do
      get :edit, :id => role.id.to_s
      assigns(:role).should eq(role)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Role" do
        expect {
          post :create, :role => valid_attributes
        }.to change(Role, :count).by(1)
      end

      it "assigns a newly created role as @role" do
        post :create, :role => valid_attributes
        assigns(:role).should be_a(Role)
        assigns(:role).should be_persisted
      end

      it "redirects to the created role" do
        post :create, :role => valid_attributes
        response.should redirect_to(admin_role_path(Role.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved role as @role" do
        Role.any_instance.stub(:save).and_return(false)
        post :create, :role => {}
        assigns(:role).should be_a_new(Role)
      end

      it "re-renders the 'new' template" do
        Role.any_instance.stub(:save).and_return(false)
        post :create, :role => {}
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested role" do
        Role.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => role.id, :role => {'these' => 'params'}
      end

      it "assigns the requested role as @role" do
        put :update, :id => role.id, :role => valid_attributes
        assigns(:role).should eq(role)
      end
      
      it "redirects to the role" do
        put :update, :id => role.id, :role => valid_attributes
        response.should redirect_to(admin_role_path(role))
      end
    end

    describe "with invalid params" do
      it "assigns the role as @role" do
        Role.any_instance.stub(:save).and_return(false)
        put :update, :id => role.id.to_s, :role => {}
        assigns(:role).should eq(role)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Role.any_instance.stub(:save).and_return(false)
        put :update, :id => role.id.to_s, :role => {}
        #response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested role" do
      expect {
        delete :destroy, :id => role.id.to_s
      }.to change(Role, :count).by(-1)
    end

    it "redirects to the roles list" do
      delete :destroy, :id => role.id.to_s
      response.should redirect_to(admin_roles_url)
    end
  end
end
