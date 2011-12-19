# -*- encoding : utf-8 -*-
class User::UsersController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_cpf

  def update
    if @user.cpf.nil?
      if @user.update_attributes(:cpf => params[:user][:cpf])
        msg = "CPF cadastrado com sucesso"
      else
        msg = "Não foi possível cadastrar o CPF"
      end
    else
      msg = "Seu CPF já está cadastrado"
    end
    redirect_to(cart_path, :notice => msg)
  end

  private

  def check_cpf
    redirect_to(cart_path, :notice => "CPF inválido") unless Cpf.new(params[:user][:cpf]).valido?
  end
end
