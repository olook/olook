# -*- encoding : utf-8 -*-
class Admin::ShippingCompaniesController < ApplicationController
  before_filter :authenticate_admin!

  layout "admin"
  respond_to :html

  def index
    @shipping_companies = ShippingCompany.all
    respond_with :admin, @shipping_companies
  end

  def show
    @shipping_company = ShippingCompany.find(params[:id])
    respond_with :admin, @shipping_company
  end

  def new
    @shipping_company = ShippingCompany.new
    respond_with :admin, @shipping_company
  end

  def edit
    @shipping_company = ShippingCompany.find(params[:id])
    respond_with :admin, @shipping_company
  end

  def create
    @shipping_company = ShippingCompany.new(params[:shipping_company])

    if @shipping_company.save
      flash[:notice] = 'Shipping company was successfully created.'
    end

    respond_with :admin, @shipping_company
  end

  def update
    @shipping_company = ShippingCompany.find(params[:id])

    if @shipping_company.update_attributes(params[:shipping_company])
      flash[:notice] = 'Shipping company was successfully updated.'
    end

    respond_with :admin, @shipping_company
  end

  def destroy
    @shipping_company = ShippingCompany.find(params[:id])
    @shipping_company.destroy
    respond_with :admin, @shipping_company
  end
end
