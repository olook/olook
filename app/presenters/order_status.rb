# -*- encoding : utf-8 -*-
class OrderStatus
  attr_accessor :order

  STATUS = {
    "order-requested"      => ["order-requested", ""],
    "payment-made-approved" => ["payment-made", "Aprovado"],
    "payment-made-denied"  => ["payment-made", "Negado"],
    "payment-made-failed"  => ["payment-made", "Falha de comunicação"],
    "order-prepared"       => ["order-prepared", "Seu pedido está sendo separado"],
    "order-delivered"      => ["order-delivered", "Entregue"],
    "order-not-delivered"  => ["order-delivered", "Não entregue"]
  }

  def initialize(order)
    @order = order
  end

  def status
    if order_requested?
      klass, message = STATUS["order-requested"]
    elsif order.completed?
      klass, message = STATUS["payment-made-approved"]
    elsif order.canceled?
      klass, message = STATUS["payment-made-denied"]
    elsif order.reversed? || order.refunded?
      klass, message = STATUS["payment-made-failed"]
    elsif order.prepared?
      klass, message = STATUS["order-prepared"]
    elsif order.delivered?
      klass, message = STATUS["order-delivered"]
    elsif order.not_delivered?
      klass, message =  STATUS["order-not-delivered"]
    end
    OpenStruct.new(:css_class => klass, :message => message)
  end

  private

  def order_requested?
    order.waiting_payment? || order.under_review? || order.started?
  end
end
