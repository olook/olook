# -*- encoding : utf-8 -*-
class PaymentsController < ApplicationController
  layout "checkout"

  include PaymentManager
  respond_to :html
  before_filter :authenticate_user!, :only => [:index]
  before_filter :load_user
  before_filter :check_order, :only => [:index]
  before_filter :check_freight, :only => [:index]

  def index
    @cart = Cart.new(@order)
  end

  def show
    @payment = @user.payments.find(params[:id])
  end

  def create
    order = Order.find_by_id(params[:id_transacao])
    if update_order(order)
      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 500
    end
  end

  private

  def update_order(order)
    if order.total_with_freight == params[:value].to_f
      order.payment.set_state(params[:status_pagamento])
    end
  end
end
