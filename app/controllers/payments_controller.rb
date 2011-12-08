# -*- encoding : utf-8 -*-
class PaymentsController < ApplicationController
  layout "checkout"

  include Ecommerce
  respond_to :html
  before_filter :authenticate_user!, :only => [:index]
  before_filter :load_user, :except => [:create]
  before_filter :check_order, :only => [:index]
  before_filter :check_freight, :only => [:index]
  protect_from_forgery :except => :create

  def index
    @cart = Cart.new(@order)
  end

  def show
    @payment = @user.payments.find(params[:id])
    @cart = Cart.new(@payment.order)
  end

  def create
    identification_code = params["id_transacao"]
    logger.error identification_code
    order = Order.find_by_identification_code(identification_code)
    if order
      if update_order(order)
        render :nothing => true, :status => 200
      else
        logger.error("Erro ao mudar status")
        render :nothing => true, :status => 500
      end
    else
      logger.error("Ordem nao encontrada")
      render :nothing => true, :status => 500
    end
  end

  private

  def update_order(order)
    logger.error params["status_pagamento"]
    order.payment.set_state(params["status_pagamento"])
  end
end
