# -*- encoding : utf-8 -*-
class AddressesController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user

  def index
    @user.addresses
    respond_with(@addresses)
  end

  def new
    @address = @user.addresses.build
  end

  def create
    @address = @user.addresses.build(params[:address])
    if @address.save
      session[:delivery_address_id] = @address.id
      redirect_to(new_payment_path, :notice => 'Endereço cadastrado com sucesso')
    else
      respond_with(@address)
    end
  end

  private
  def load_user
    @user = current_user
  end
end
