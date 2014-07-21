# encoding: UTF-8
class Admin::B2bOrdersController < Admin::BaseController
  authorize_resource :class => false

  def index
  end

  def create
    csv = params[:b2b_order].delete(:order_items_file)

    result = B2bOrderGenerator.new.run(params[:b2b_order], csv.try(:path))
    if result[:error].present?
      flash[:error] = "#{result[:error]}"
    else
      flash[:notice] = "Pedido #{result[:order]} criado com sucesso. Confira no abacos"
    end

    render :index
  end

end
