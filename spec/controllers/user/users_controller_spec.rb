# -*- encoding : utf-8 -*-
require 'spec_helper'

describe User::UsersController do

  let(:user) { FactoryGirl.create :user }
  let(:cpf) { "06723914651" }

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end

  describe "PUT update" do
    it "should updates the CPF" do
      User.any_instance.should_receive(:update_attributes).with(:cpf => cpf)
      put :update, :id => user.id, :user => {:cpf => cpf}
    end

    it "should not updates the CPF when already has one" do
      user.update_attributes(:cpf => cpf)
      User.any_instance.should_not_receive(:update_attributes).with(:cpf => cpf)
      put :update, :id => user.id, :user => {:cpf => cpf}
    end
  end
end
