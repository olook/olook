class Api::V1::AddressesController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!

  def index
    # binding.pry
    # respond_to do |format|
    #   format.json {render json: current_user.addresses.to_json }
    # end

    render json: current_user.addresses.to_json
  end

  def destroy
    address = current_user.addresses.find_by_id(params[:id])
    address.destroy
    render json: address.to_json, status: :ok
  end

  def create
    address = current_user.addresses.create(params[:address])
    if address.valid?
      render json: address.to_json, status: :created
    else  
      render json: address.errors.to_json, status: 422
    end
  end

  def show
    
  end

end
