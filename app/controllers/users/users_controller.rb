# -*- encoding : utf-8 -*-
class Users::UsersController < ApplicationController
  respond_to :html

  before_filter :check_cpf, :only => [:update]


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
