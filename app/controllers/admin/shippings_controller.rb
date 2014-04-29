#encoding: utf-8
class Admin::ShippingsController < Admin::BaseController
  def update
    if params[:shipping_file]
      temp_file_uploader = TempFileUploader.new
      temp_file_uploader.store!(params[:shipping_file])
      ShippingImporterService.new(temp_file_uploader.filename, ShippingParserService.new).process_file
    end
    redirect_to :back
  end

end
