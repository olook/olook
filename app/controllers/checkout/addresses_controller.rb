# -*- encoding : utf-8 -*-
class Checkout::AddressesController < Checkout::BaseController

  before_filter :authenticate_user!
  before_filter :check_order
  before_filter :erase_freight

  def index
    redirect_to new_cart_checkout_address_path unless @user.addresses.any?
    
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
      redirect_to new_cart_checkout_path
    else
      respond_with(@address)
    end
  end

  def update
    @address = @user.addresses.find(params[:id])
    if @address.update_attributes(params[:address])
      set_freight_in_the_order(@address)
      redirect_to new_cart_checkout_path
    else
      respond_with(@address)
    end
  end

  def destroy
    @address = @user.addresses.find(params[:id])
    session[:freight] = nil
    @address.destroy
    redirect_to(cart_checkout_addresses_path)
  end

  def assign_address
    address = @user.addresses.find_by_id(params[:address_id])
    if address
      set_freight_in_the_order(address)
      redirect_to new_cart_checkout_path
    else
      redirect_to cart_checkout_addresses_path, :notice => "Por favor, selecione um endereço"
    end
  end
  
  private
  def set_freight_in_the_order(address)
    freight = FreightCalculator.freight_for_zip(address.zip_code, @cart.total)
    freight.merge!(:address_id => address.id)
    session[:freight] = Freight.new(freight)
  end
end
