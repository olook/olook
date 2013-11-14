# encoding: UTF-8
class Admin::VisibilityBatchController < Admin::BaseController
  respond_to :html
  def new
  end

  def index
    @liquidation_previews = LiquidationPreview.all
  end

  def create
    LiquidationPreview.import_csv params[:file]
    message = nil
    message ||= "Visibilidade alterada com sucesso!"
    redirect_to admin_new_visibility_batch_path, notice: message
  end

  def export
    out = CSV.generate do |csv|
      Product.all.each do |product|
        csv << [product.id, product.visibility]
      end
    end

    send_data out
  end

end
