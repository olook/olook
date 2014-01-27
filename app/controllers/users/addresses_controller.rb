# -*- encoding : utf-8 -*-
class Users::AddressesController < ApplicationController

  respond_to :html
  before_filter :authenticate_user!

  def index
    @addresses = @user.addresses
  end

  def new
    @address = @user.addresses.build
  end

  def edit
    @address = @user.addresses.find(params[:id])
  end

  def create
    params[:address][:country] = 'BRA'
    
    @address = @user.addresses.build(params[:address])
    if @address.save
      redirect_to(user_addresses_path)
    else
      respond_with(@address)
    end
  end

  def update
    @address = @user.addresses.find(params[:id])
    if @address.update_attributes(params[:address])
      redirect_to(user_addresses_path)
    else
      respond_with(@address)
    end
  end

  def destroy
    @address = @user.addresses.find(params[:id])
    if @address.destroy
      redirect_to(user_addresses_path)
    else
      respond_with(@address)
    end
  end

  private

  def load_user
    @user = current_user
  end
end
