# encoding: UTF-8
class Admin::BilletBatchController < Admin::BaseController
  respond_to :html  
  def new
  end

  def create
    save_file params[:batch_file].tempfile.read
    Resque.enqueue(Admin::ProcessBilletFileWorker)
    redirect_to admin_new_billet_batch_path, notice: "Estamos processando o arquivo. Assim que terminar, um e-mail será enviado."
  end

end
