# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SessionsController do

  context "User login" do
    describe "Post 'create'" do
      it "should redirect to the invite people page" do
        request.env['devise.mapping'] = Devise.mappings[:user]
        user = Factory(:user)
        post :create, :user => { :email => user.email, :password => user.password }
        response.should redirect_to(member_invite_path)
      end
    end
  end

  context "Admin login" do
    describe "Post 'create'" do
      it "should redirect to admin page" do
        request.env['devise.mapping'] = Devise.mappings[:admin]
        admin = Factory(:admin)
        post :create, :admin => { :email => admin.email, :password => admin.password }
        response.should redirect_to(admin_path)
      end
    end
  end

end
