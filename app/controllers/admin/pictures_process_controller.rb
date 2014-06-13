class Admin::PicturesProcessController < Admin::BaseController
  def index
    authorize! :new_multiple_pictures, Picture
    @keys = PictureProcess.list(prefix: params[:prefix]).paginate(page: params[:page], per_page: 30)
  end

  def create
    authorize! :create_multiple_pictures, Picture
    Resque.enqueue(PictureProcess, {"key" => params[:key], "user_email" => current_admin.email})
    redirect_to admin_pictures_process_path, notice: 'Processamento está sendo realizado. Aguarde o email com as informações'
  end
end
