# -*- encoding : utf-8 -*-
class Checkout::AddressesController < Checkout::BaseController
  respond_to :html, :js
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
    @cart_service.freight = calculate_freight_to_cart(@address)
  end

  def create
    params[:address][:country] = 'BRA' if params[:address]
    @address = @user.addresses.build(params[:address])
    if @address.save
      set_telephone_user(@address.telephone)
      set_freight_in_the_cart(@address)
      redirect_to new_credit_card_cart_checkout_path
    else
      respond_with(@address)
    end
  end

  def update
    @address = @user.addresses.find(params[:id])
    if @address.update_attributes(params[:address])
      set_freight_in_the_cart(@address)
      redirect_to new_credit_card_cart_checkout_path
    else
      respond_with(@address)
    end
  end

  def destroy
    @address = @user.addresses.find(params[:id])
    session[:cart_freight] = nil
    @address.destroy
    redirect_to(cart_checkout_addresses_path)
  end

  def preview
    address = Address.new(:zip_code => params[:zipcode])
    @cart_service.freight = calculate_freight_to_cart(address)
  end

  private
  def set_freight_in_the_cart(address)
    session[:cart_freight] = calculate_freight_to_cart(address)
  end

  def calculate_freight_to_cart(address)
    freight = FreightCalculator.freight_for_zip(address.zip_code, @cart_service.total)
    freight.merge!(:address_id => address.id)
  end

  def set_telephone_user(telephone)
    session[:user_telephone_number] = telephone
  end

end
