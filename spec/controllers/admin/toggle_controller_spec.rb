# -*- encoding : utf-8 -*-
require 'spec_helper'
describe Admin::ToggleController do

  let!(:admin) { FactoryGirl.create(:admin_sac_operator) }

  let!(:valid_attributes_with_password){
    {:first_name => "Doug", :last_name => "Funny", :password => "123456",
    :password_confirmation => "123456", :email => "drfunny@olook.com.br",
    :role_id => admin.role_id.to_s} }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:admin]
    @admin = FactoryGirl.create(:admin_superadministrator)
    sign_in @admin
  end

  describe "GET switch_mode"
  context "admin trying change mode view of products"
   it "switching admin mode view admin to user" do
    @request.env['HTTP_REFERER'] = root_path
    session[:product_view_mode] = "admin"
    get :switch_mode
    session[:product_view_mode].should eq("user")
   end

   it "switching admin mode view user to admin" do
    @request.env['HTTP_REFERER'] = root_path
    session[:product_view_mode] = "user"
    get :switch_mode
    session[:product_view_mode].should eq("admin")
   end

  end
