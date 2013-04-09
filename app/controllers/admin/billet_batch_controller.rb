# encoding: UTF-8
class Admin::BilletBatchController < Admin::BaseController
  respond_to :html  
  def new
  end

  def create
    save_file params[:batch_file].tempfile.read
    # Resque.enqueue
    redirect_to admin_new_billet_batch_path, notice: "Estamos processando o arquivo. Assim que terminar, um e-mail será enviado."
  end

  private

  def save_file(file_content)
    MarketingReports::FileUploader.new("teste.txt", file_content).save_local_file
    MarketingReports::FileUploader.copy_file("teste.txt", "/tmp") if Rails.env.production?
  end
end
