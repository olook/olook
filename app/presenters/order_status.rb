# -*- encoding : utf-8 -*-
class OrderStatus
  attr_accessor :order

  STATUS = {
    "order-requested"         => ["order-requested" , "Seu pedido foi feito e estamos aguardando aprovação do pagamento."],
    "payment-made-authorized" => ["payment-made"    , "Aprovado"],
    "payment-made-denied"     => ["payment-made"    , "Negado"],
    "payment-made-failed"     => ["payment-made"    , "Falha de comunicação"],
    "order-picking"           => ["order-picking"   , "Seu pedido está sendo separado"],
    "order-delivering"        => ["order-picking"   , "Em trânsito"],
    "order-delivered"         => ["order-deliver"   , "Entregue"],
    "order-not-delivered"     => ["order-deliver"   , "Não entregue"]
  }

  def initialize(order)
    @order = order
  end

  def status
    if order_requested?
      klass, message = STATUS["order-requested"]
    elsif order.authorized?
      klass, message = STATUS["payment-made-authorized"]
    elsif order.canceled?
      klass, message = STATUS["payment-made-denied"]
    elsif order.reversed? || order.refunded?
      klass, message = STATUS["payment-made-failed"]
    elsif order.picking?
      klass, message = STATUS["order-picking"]
    elsif order.delivering?
      klass, message = STATUS["order-delivering"]
    elsif order.delivered?
      klass, message = STATUS["order-delivered"]
    elsif order.not_delivered?
      klass, message =  STATUS["order-not-delivered"]
    end
    OpenStruct.new(:css_class => klass, :message => message)
  end

  private

  def order_requested?
    order.waiting_payment? || order.under_review?
  end
end
