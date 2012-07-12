# -*- encoding : utf-8 -*-
class ::AddressesController < ApplicationController
  layout "checkout"

  respond_to :html
  before_filter :authenticate_user!, :except => [:get_address_by_zipcode]
  before_filter :check_order, :except => [:get_address_by_zipcode]
  before_filter :check_address, :only => [:index]
  before_filter :erase_freight

  def index
    @addresses = @user.addresses
  end

  def new
    @address = @user.addresses.build(:first_name => @user.first_name, :last_name => @user.last_name)
  end

  def edit
    @address = @user.addresses.find(params[:id])
  end

  def create
    params[:address][:country] = 'BRA'
    @address = @user.addresses.build(params[:address])
    if @address.save
      set_freight_in_the_order(@address)
      redirect_to(@user.cpf.nil? ? payments_path : new_credit_card_path)
    else
      respond_with(@address)
    end
  end

  def update
    @address = @user.addresses.find(params[:id])
    if @address.update_attributes(params[:address])
      set_freight_in_the_order(@address)
      redirect_to(addresses_path)
    else
      respond_with(@address)
    end
  end

  def destroy
    @address = @user.addresses.find(params[:id])
    session[:freight] = nil
    @address.destroy
    redirect_to(addresses_path)
  end

  def assign_address
    address = @user.addresses.find_by_id(params[:delivery_address_id])
    if address
      set_freight_in_the_order(address)
      redirect_to(@user.cpf.nil? ? payments_path : new_credit_card_path)
    else
      redirect_to addresses_path, :notice => "Por favor, selecione um endereço"
    end
  end
  
  def get_address_by_zipcode
    result = ZipCodeAdapter.get_address(params[:zipcode])
    render json: result
  end

  private
  def erase_freight
    @cart.freight = nil
  end

  def check_address
    redirect_to new_address_path unless @user.addresses.any?
  end

  def set_freight_in_the_order(address)
    freight = FreightCalculator.freight_for_zip(address.zip_code, @cart.total)
    freight.merge!(:address_id => address.id)
    session[:freight] = Freight.new(freight)
  end
  
  def check_order
    redirect_to(cart_path, :notice => "Sua sacola está vazia") if @cart.items_total <= 0
  end
end
