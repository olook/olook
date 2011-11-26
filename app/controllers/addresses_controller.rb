# -*- encoding : utf-8 -*-
class AddressesController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :assign_default_country, :only => [:create]

  def index
    @addresses = @user.addresses
  end

  def new
    @address = @user.addresses.build
  end

  def create
    @address = @user.addresses.build(params[:address])
    if @address.save
      session[:delivery_address_id] = @address.id
      redirect_to(payments_path, :notice => 'Endereço cadastrado com sucesso')
    else
      respond_with(@address)
    end
  end

  def assign_address
    session[:delivery_address_id] = params[:delivery_address_id]
    redirect_to payments_path
  end

  private
  def load_user
    @user = current_user
  end

  def assign_default_country
    params[:address][:country] = 'BRA'
  end
end
