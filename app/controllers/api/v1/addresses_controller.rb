class Api::V1::AddressesController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!

  def index
    render json: current_user.addresses.to_json
  end

  def destroy
    address = current_user.addresses.find_by_id(params[:id])
    address.destroy
    render json: address.to_json, status: :ok
  end

  def create
    params[:address][:country] = 'BRA' if params[:address]    
    address = current_user.addresses.create(params[:address])
    if address.valid?
      render json: address.to_json, status: :created
    else  
      render json: address.errors.to_json, status: :unprocessable_entity
    end
  end

  def update
    address = current_user.addresses.active.find(params[:id])
    if address.update_attributes(params[:address])
      render json: address.to_json, status: :ok
    else  
      render json: address.errors.to_json, status: :unprocessable_entity
    end
  end  

  def show
    address = current_user.addresses.find_by_id(params[:id])
    render json: address.to_json, status: :ok    
  end

end
