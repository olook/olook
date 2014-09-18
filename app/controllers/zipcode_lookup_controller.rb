class ZipcodeLookupController < ApplicationController
  respond_to :json, :js

  def get_address_by_zipcode
    result = ZipCodeAdapter.get_address(params[:zipcode])
    render json: result
  end

  def address_data
    result = ZipCodeAdapter.get_address(params[:zip_code])
    result.delete(:result_type)
    @cart_calculator = CartProfit::CartCalculator.new(@cart)
    @address = @user.addresses.build(:first_name => @user.first_name, :last_name => @user.last_name)
    @address.zip_code = params[:zip_code]
    @address.assign_attributes result
  end

end
