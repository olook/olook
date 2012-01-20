class Admin::CouponsController < ApplicationController
  respond_to :html
  before_filter :authenticate_admin!
  before_filter :load_coupon, :only => [:show, :edit, :update, :destroy]

  layout 'admin'

  def index
    @coupons = Coupon.page(params[:page]).per_page(20).order('id DESC')
  end

  def show
  end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.new(params[:coupon])
    if @coupon.save
      redirect_to admin_coupons_path, :notice => "Coupon was successfully created."
    else
      flash[:error] = 'A problem occurred while trying to create the coupon.'
      respond_with :admin, @coupon
    end
  end

  def edit
  end

  def update
    if @coupon.update_attributes(params[:coupon])
      redirect_to admin_coupons_path, :notice => "Coupon was successfully updated."
    else
      flash[:error] = "A problem occurred while trying to update the coupon."
      respond_with :admin, @coupon
    end
  end

  private

  def load_coupon
    @coupon = Coupon.find(params[:id])
  end
end
