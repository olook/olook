class ResellerController < ApplicationController
  layout "lite_application"
  def new
    @reseller = Reseller.new
    @reseller.addresses.build
  end

  def create
    @reseller = Reseller.new(params[:reseller])
    if @reseller.save
    else
      redirect_to reseller_show_path
    end
  end

  def show
  end

end
