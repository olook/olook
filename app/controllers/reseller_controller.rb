class ResellerController < ApplicationController
  layout "lite_application"
  def new
    @reseller = Reseller.new
    @reseller.addresses.build
  end

  def create
    @reseller = Reseller.new(params[:reseller])
    if @reseller.save
      redirect_to reseller_show_path
    else
      render "new"
    end
  end

  def show
  end

end
