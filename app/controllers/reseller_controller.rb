class ResellerController < ApplicationController
  layout "lite_application"
  def index
    @reseller = Reseller.new
    @reseller.addresses.build
  end

  def show
  end

end
