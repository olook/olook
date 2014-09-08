# -*- encoding : utf-8 -*-
class BetaController < ApplicationController

  PAYMENTS = {
    CreditCard: 'Cartão de Crédito',
    Billet: 'Boleto Bancário',
    Debit: 'Débito em Conta',
    MercadoPagoPayment: 'MercadoPago'
  }


  def index
    render layout: 'lite_checkout'
  end

  def confirmation
    @order = Order.find_by_number(params[:number])

    @payment_method = @order.erp_payment.type.downcase
    @payment_description = PAYMENTS[@order.erp_payment.type.to_sym]

    @has_long_cart = !!params[:lc]
    render layout: 'lite_checkout'
  end



end
