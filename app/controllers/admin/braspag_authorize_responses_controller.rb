class Admin::BraspagAuthorizeResponsesController < Admin::BaseController
  respond_to :html

  load_and_authorize_resource

  def index
  	@search = BraspagAuthorizeResponse.search(params[:search])
  	@responses = @search.relation.page(params[:page]).per_page(50).order('processed asc, id asc')
  end

  def show
  	@response = BraspagAuthorizeResponse.find(params[:id])
  	@payment = Payment.find_by_identification_code(@response.identification_code)
  	respond_with :admin, @response, @payment
  end

  def change_to_processed
    @response = BraspagAuthorizeResponse.find(params[:id])
    if (not @response.processed?)
      @response.processed = true
      if @response.save
        flash[:notice] = 'A authorize response foi marcada como processada com sucesso.'
      else
        flash[:error] = 'Nao foi possivel atualizar o authorize response como processada.'
      end
    else
      flash[:error] = 'A authorize response ja foi processada.'
    end
    respond_with :admin, @response
  end

  def change_to_not_processed
    @response = BraspagAuthorizeResponse.find(params[:id])
    if (@response.processed?)
      @response.processed = false
      if @response.save
        flash[:notice] = 'A authorize response foi marcada como nao processada, e sera reprocessada em breve.'
      else
        flash[:error] = 'Nao foi possivel atualizar o authorize response como nao processada.'
      end
    else
      flash[:error] = 'A authorize response ainda nao foi processada.'
    end
    respond_with :admin, @response
  end

end
