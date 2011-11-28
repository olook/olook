# -*- encoding : utf-8 -*-
class User::AddressesController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user

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
    @address = @user.addresses.build(params[:address])
    if @address.save
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
