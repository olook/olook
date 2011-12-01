# -*- encoding : utf-8 -*-
class ::AddressesController < ApplicationController
  include PaymentManager
  respond_to :html
  before_filter :authenticate_user!
  before_filter :load_user
  before_filter :check_order
  before_filter :assign_default_country, :only => [:create]
  before_filter :build_cart, :except => [:assign_address]

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
      assign_address_and_freight_in_the_session(@address)
      redirect_to(payments_path)
    else
      respond_with(@address)
    end
  end

  def update
    @address = @user.addresses.find(params[:id])
    if @address.update_attributes(params[:address])
      assign_address_and_freight_in_the_session(@address)
      redirect_to(payments_path)
    else
      respond_with(@address)
    end
  end

  def destroy
    @address = @user.addresses.find(params[:id])
    if @address.destroy
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

  def build_cart
    @cart = Cart.new(@order)
  end

  def assign_address_and_freight_in_the_session(address)
    freight = FreightCalculator.freight_for_zip(address.zip_code, @order.total)
    freight.merge!(:address_id => address.id)

    if @order.freight
      @order.freight.update_attributes(freight)
    else
      @order.create_freight(freight)
    end
  end
end
