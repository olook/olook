# -*- encoding : utf-8 -*-
class Admin::OrdersController < Admin::BaseController
  
  load_and_authorize_resource
  
  respond_to :html, :json

  def index
    @search = Order.with_payment.search(params[:search])
    @orders = @search.relation.page(params[:page]).per_page(20).order('id DESC')
  end

  def show
    @order = Order.find(params[:id])
    @address = @order.freight.address
    respond_with :admin, @order, @address
  end

  def generate_purchase_timeline
    timeline = ::OrderTimeline::TimelineTrack.find_by_order_id(params[:id])
    respond_with timeline.timeline_track
  end

end
