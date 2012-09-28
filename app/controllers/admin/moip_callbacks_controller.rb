class Admin::MoipCallbacksController < Admin::BaseController
  respond_to :html

  load_and_authorize_resource

  def index
  	@search = MoipCallback.search(params[:search])
  	@moip_callbacks = @search.relation.page(params[:page]).per_page(100).order('processed asc, id asc')
  end

  def show
  	@moip_callback = MoipCallback.find(params[:id])
  	@payment = Payment.find_by_identification_code(@moip_callback.id_transacao)
  	respond_with :admin, @moip_callback, @payment
  end

end