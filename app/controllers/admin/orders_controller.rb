# -*- encoding : utf-8 -*-
class Admin::OrdersController < Admin::BaseController

  load_and_authorize_resource

  respond_to :html, :json

  def index
    @search = Order.search(params[:search])
    @orders = @search.relation.page(params[:page]).per_page(20).order('id DESC')
  end

  def show
    @order = Order.find(params[:id])
    @address = @order.freight.address if @order.freight
    respond_with :admin, @order, @address
  end

  def change_state
    @order = Order.find(params[:id])

    if params[:event].in?(@order.state_events(guard: false).map(&:to_s))
      @order.public_send(params[:event])
      flash[:notice] = 'O estado da ordem foi atualizado com sucesso!'
    else
      flash[:error] = 'Não foi possível alterar o estado!'
    end

    respond_with :admin, @order
  end

  def generate_purchase_timeline
   @order = Order.find(params[:id])
  end

  def integrate_orders
    Order.where(:erp_integrate_at => nil).find_each do |order|
      Resque.enqueue(Abacos::InsertOrder, order.number)
    end
    redirect_to admin_orders_path, :notice => "Integrate Orders, checking Resque"
  end

  def integrate_payment
    Order.with_payment.where(:erp_payment_at => nil, :state => "authorized").find_each do |order|
      Resque.enqueue(Abacos::ConfirmPayment, order.number)
    end
    redirect_to admin_orders_path, :notice => "Integrate Payment, checking Resque"
  end

  def integrate_cancel
    Order.where(:erp_cancel_at => nil, :state => "canceled").find_each do |order|
      Resque.enqueue(Abacos::CancelOrder, order.number)
    end
    redirect_to admin_orders_path, :notice => "Integrate Cancel Orders, checking Resque"
  end

  def remove_loyalty_credits
    @order = Order.find(params[:id])
    line_item = LineItem.find(params[:line_item_id])
    debits = line_item.remove_loyalty_credits
    if debits.try(:empty?)
      flash[:error] = "Não foi possível remover os créditos de fidelidade."
    else
      flash[:notice] = "Creditos removidos com sucesso!"
    end
    respond_with :admin, @order
  end

  def authorize_payment
    @order = Order.find(params[:id])
    @order.authorize_erp_payment

    redirect_to admin_orders_path
  end

end
