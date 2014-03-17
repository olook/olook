class Admin::MoipCallbacksController < Admin::BaseController
  load_and_authorize_resource
  respond_to :html

  def index
    @search = MoipCallback.search(params[:search])
    @moip_callbacks = @search.relation.page(params[:page]).per_page(100).order('processed asc, id asc')
  end

  def show
    @moip_callback = MoipCallback.find(params[:id])
    @payment = Payment.find_by_identification_code(@moip_callback.id_transacao)
    respond_with :admin, @moip_callback, @payment
  end

  def change_to_processed
    @moip_callback = MoipCallback.find(params[:id])
    if (not @moip_callback.processed?)
      @moip_callback.processed = true
      if @moip_callback.save
        flash[:notice] = 'O moip callback foi marcado como processado com sucesso.'
      else
        flash[:error] = 'Nao foi possivel atualizar o moip callback como processado.'
      end
    else
      flash[:error] = 'O moip callback ja foi processado'
    end
    respond_with :admin, @moip_callback
  end

  def change_to_not_processed
    @moip_callback = MoipCallback.find(params[:id])
    if (@moip_callback.processed?)
      @moip_callback.processed = false
      if @moip_callback.save
        flash[:notice] = 'O moip callback foi marcado como nao processado, e sera reprocessado em breve.'
      else
        flash[:error] = 'Nao foi possivel atualizar o moip callback como nao processado.'
      end
    else
      flash[:error] = 'O moip callback ainda nao foi processado'
    end
    respond_with :admin, @moip_callback
  end
end
