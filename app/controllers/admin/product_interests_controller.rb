# encoding: utf-8
class Admin::ProductInterestsController < Admin::BaseController
  load_and_authorize_resource
  respond_to :html, :csv
  def index
    @search = ProductInterest.search(params[:search])
    @product_interests = @search.relation
    respond_to do |format|
      format.html {
        @product_interests = @product_interests.page(params[:page]).per_page(50)
      }
      format.csv { send_data @product_interests.as_csv }
    end
  end
end
