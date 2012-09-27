class Admin::MoipCallbacksController < Admin::BaseController
  respond_to :html

  load_and_authorize_resource

  def index
  	@search = MoipCallback.search(params[:search])
  	@moip_callbacks = @search.relation.page(params[:page]).per_page(100).order('processed asc, id asc')
  end

end