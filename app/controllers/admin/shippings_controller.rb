#encoding: utf-8
class Admin::ShippingsController < Admin::BaseController
  def update
    if params[:shipping_file]
      temp_file_uploader = TempFileUploader.new
      temp_file_uploader.store!(params[:shipping_file])
      process_file temp_file_uploader.filename
      # Resque.enqueue(ImportFreightPricesWorker, @shipping_service.id.to_s, temp_file_uploader.filename)
    end
    redirect_to :back
  end
  def destroy
  end

  private
  def process_file filename
    load_data filename
  end
  def load_data(temp_filename)
    temp_file_uploader = TempFileUploader.new
    temp_file_uploader.retrieve_from_store!(temp_filename)
    temp_file_uploader.cache_stored_file!

    CSV.read(temp_file_uploader.file.path, {:col_sep => ';'})
  end
end
