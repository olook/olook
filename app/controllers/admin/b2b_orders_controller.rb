# encoding: UTF-8
class Admin::B2bOrdersController < Admin::BaseController
  authorize_resource :class => false

  def index
  end

  def create
    csv = params[:b2b_order].delete(:order_items_file)
    order_number = ShowroomOrderGenerator.new.run(params[:b2b_order])   
    flash[:notice] = "Pedido #{order_number} criado com sucesso. Confira no abacos"
    # redirect_to admin_b2b_orders
    render :index
  end

end
