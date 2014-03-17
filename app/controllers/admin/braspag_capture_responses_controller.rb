class Admin::BraspagCaptureResponsesController < Admin::BaseController
  load_and_authorize_resource
  respond_to :html

  def index
    @search = BraspagCaptureResponse.search(params[:search])
    @responses = @search.relation.page(params[:page]).per_page(100).order('processed asc, id asc')
  end

  def show
    @response = BraspagCaptureResponse.find(params[:id])
    @payment = Payment.find_by_identification_code(@response.identification_code)
    respond_with :admin, @response, @payment
  end

  def change_to_processed
    @response = BraspagCaptureResponse.find(params[:id])
    if (not @response.processed?)
      @response.processed = true
      if @response.save
        flash[:notice] = 'A capture response foi marcada como processada com sucesso.'
      else
        flash[:error] = 'Nao foi possivel atualizar o capture response como processada.'
      end
    else
      flash[:error] = 'A capture response ja foi processada.'
    end
    respond_with :admin, @response
  end

  def change_to_not_processed
    @response = BraspagCaptureResponse.find(params[:id])
    if (@response.processed?)
      @response.processed = false
      if @response.save
        flash[:notice] = 'A capture response foi marcada como nao processada, e sera reprocessada em breve.'
      else
        flash[:error] = 'Nao foi possivel atualizar o capture response como nao processada.'
      end
    else
      flash[:error] = 'A capture response ainda nao foi processada.'
    end
    respond_with :admin, @response
  end
end
