class ZipcodeLookupController < ApplicationController

  respond_to :json, :js

  def get_address_by_zipcode
    result = ZipCodeAdapter.get_address(params[:zipcode])
    render json: result
  end
end
