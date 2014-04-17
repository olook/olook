# -*- encoding : utf-8 -*-
class Users::AddressesController < ApplicationController

  respond_to :html
  before_filter :authenticate_user!
  before_filter :retrieve_address, only: [:edit, :update, :destroy]

  def index
    @addresses = @user.addresses.active
  end

  def new
    @address = @user.addresses.build
  end

  def edit
  end

  def create
    @address = @user.addresses.build(params[:address])
    if @address.save
      redirect_to(user_addresses_path)
    else
      respond_with(@address)
    end
  end

  def update
    if @address.update_attributes(params[:address])
      redirect_to(user_addresses_path)
    else
      respond_with(@address)
    end
  end

  def destroy
   @address.update_attribute(:active, false)
   redirect_to :back
  end

  private

  def retrieve_address
    @address = @user.addresses.active.find(params[:id])
  end
end
