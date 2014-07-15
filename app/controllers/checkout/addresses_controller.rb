# -*- encoding : utf-8 -*-
class Checkout::AddressesController < Checkout::BaseController
  respond_to :html, :js, :json
  before_filter :authenticate_user!
  before_filter :check_order
  before_filter :retrieve_address, only: [:edit, :update, :destroy]

  def index
    redirect_to new_checkout_address_url(protocol: ( Rails.env.development? ? 'http' : 'https' )) unless @user.addresses.any?
    @addresses = @user.addresses.active
  end

  def new
    @address = @user.addresses.build(:first_name => @user.first_name, :last_name => @user.last_name)
  end

  def edit
  end

  def create
    params[:address][:country] = 'BRA' if params[:address]
    @address = @user.addresses.build(params[:address])
    if @address.save
      redirect_to new_checkout_url(protocol: ( Rails.env.development? ? 'http' : 'https' ))
    else
      respond_with(@address)
    end
  end

  def update
    if @address.update_attributes(params[:address])
      redirect_to new_checkout_url(protocol: ( Rails.env.development? ? 'http' : 'https' ))
    else
      respond_with(@address)
    end
  end

  def destroy
    @address.destroy
    redirect_to(checkout_addresses_path)
  end

  def preview
    Address.new(:zip_code => params[:zipcode])
  end

  private

  def retrieve_address
    @address = @user.addresses.active.find(params[:id])
  end
end
