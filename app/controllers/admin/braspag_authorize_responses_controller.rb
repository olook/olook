class Admin::BraspagAuthorizeResponsesController < Admin::BaseController
  respond_to :html

  load_and_authorize_resource

  def index
  	@search = BraspagAuthorizeResponse.search(params[:search])
  	@responses = @search.relation.page(params[:page]).per_page(100).order('processed asc, id asc')
  end

  def show
  	@response = BraspagAuthorizeResponse.find(params[:id])
  	@payment = Payment.find_by_identification_code(@response.identification_code)
  	respond_with :admin, @response, @payment
  end

end
