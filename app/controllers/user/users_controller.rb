# -*- encoding : utf-8 -*-
class User::UsersController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_cpf, :only => [:update]

  def destroy_facebook_account
    @user.update_attributes(:uid => nil, :facebook_token => nil, :has_facebook_extended_permission => false)
    redirect_to(member_showroom_path, :notice => "Sua conta do Facebook foi removida com sucesso")
  end

  def update
    if @user.cpf.nil?
      @user.require_cpf = true
      if @user.update_attributes(:cpf => params[:user][:cpf])
        msg = "CPF cadastrado com sucesso"
      else
        msg = "CPF já cadastrado"
      end
    end
    redirect_to(payments_path, :notice => msg)
  end

  private

  def check_cpf
    redirect_to(payments_path, :notice => "CPF inválido") unless Cpf.new(params[:user][:cpf]).valido?
  end
end
