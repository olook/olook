# encoding: UTF-8
class Admin::VisibilityBatchController < Admin::BaseController
  respond_to :html
  def commit
    LiquidationPreview.update_visibility_in_products
    message = "Produtos atualizados com sucesso!"
    redirect_to admin_products_path(params: {visibility: 2}), notice: message    
  end

  def new
  end

  def confirmation
    @liquidation_previews = LiquidationPreview.paginate(page: params[:page], per_page: 10)
  end

  def create
    LiquidationPreview.import_csv params[:file]
    message = nil
    redirect_to admin_confirmation_visibility_batch_path, notice: message
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
