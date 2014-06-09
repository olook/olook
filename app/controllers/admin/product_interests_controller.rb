# encoding: utf-8
class Admin::ProductInterestsController < Admin::BaseController
  load_and_authorize_resource
  respond_to :html
  def index
    @product_interests = ProductInterest.all
  end
end
