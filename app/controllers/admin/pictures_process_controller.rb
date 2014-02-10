class Admin::PicturesProcessController < Admin::BaseController
  def index
    authorize! :new_multiple_pictures, Picture
    @keys = PictureProcess.list(prefix: params[:prefix])
  end

  def create
    authorize! :create_multiple_pictures, Picture
    Resque.enqueue(PictureProcess, key: params[:key])
    redirect_to admin_pictures_process_path notice: 'Processamento enfileirado. Aguarde o email daqui alguns minutos'
  end
end
