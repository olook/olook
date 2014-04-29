#encoding: utf-8
class Admin::ShippingPoliciesController < Admin::BaseController
  def update
    if params[:policy_file]
      temp_file_uploader = TempFileUploader.new
      temp_file_uploader.store!(params[:policy_file])
      ShippingImporterService.new(temp_file_uploader.filename, ShippingPolicyParserService.new).process_file
    end
    redirect_to :back
  end

end
