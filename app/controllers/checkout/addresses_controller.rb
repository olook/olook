# -*- encoding : utf-8 -*-
class Checkout::AddressesController < Checkout::BaseController
  respond_to :html, :js
  before_filter :authenticate_user!
  before_filter :check_order

  def index
    redirect_to new_checkout_address_url(protocol: 'https') unless @user.addresses.any?
    @addresses = @user.addresses
  end

  def new
    @address = @user.addresses.build(:first_name => @user.first_name, :last_name => @user.last_name)
  end

  def edit
    @address = @user.addresses.find(params[:id])
  end

  def create
    params[:address][:country] = 'BRA' if params[:address]
    @address = @user.addresses.build(params[:address])
    if @address.save
      redirect_to new_checkout_url(protocol: 'https')
    else
      respond_with(@address)
    end
  end

  def update
    @address = @user.addresses.find(params[:id])
    if @address.update_attributes(params[:address])
      redirect_to new_checkout_url(protocol: 'https')
    else
      respond_with(@address)
    end
  end

  def destroy
    @address = @user.addresses.find(params[:id])
    @address.destroy
    redirect_to(checkout_addresses_path)
  end

  def preview
    address = Address.new(:zip_code => params[:zipcode])
  end

end
