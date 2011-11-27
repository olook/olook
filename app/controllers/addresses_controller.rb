# -*- encoding : utf-8 -*-
class AddressesController < ApplicationController
  include PaymentManager
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_order, :except => [:index]
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
      assign_address_and_freight_in_the_session(@address)
      redirect_to(payments_path)
    else
      respond_with(@address)
    end
  end

  def assign_address
    address = @user.addresses.find_by_id(params[:delivery_address_id])
    if address
      assign_address_and_freight_in_the_session(address)
      redirect_to(payments_path)
    else
      redirect_to addresses_path
    end
  end

  private

  def assign_address_and_freight_in_the_session(address)
    session[:delivery_address_id] = address.id
    session[:freight] = FreightCalculator.freight_for_zip(address.zip_code, @order.total)
  end

  def assign_default_country
    params[:address][:country] = 'BRA'
  end
end
