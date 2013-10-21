class ResellerController < ApplicationController
  layout "lite_application"
  def index
    @reseller = Reseller.new
  end

  def show
  end

end
