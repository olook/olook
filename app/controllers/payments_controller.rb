# -*- encoding : utf-8 -*-
class PaymentsController < ApplicationController
  include PaymentManager
  respond_to :html
  before_filter :authenticate_user!, :only => [:index]
  before_filter :load_user, :only => [:index]
  before_filter :check_order, :only => [:index]
  before_filter :check_freight, :only => [:index]
  before_filter :check_user_address, :only => [:index]

  def index
    @cart = Cart.new(@order, @freight)
  end

  def create
    order = Order.find_by_id(params[:id_transacao])
    if order.payment.set_state(params[:status_pagamento])
      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 500
    end
  end
end
