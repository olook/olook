# -*- encoding : utf-8 -*-
class OrderStatusMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "olook <avisos@olook.com.br>"

  [:order_requested, :payment_confirmed, :payment_refused].each do |method|
    define_method method do |order|
      @order = order
      send_mail(@order)
    end
  end

  private

  def build_subject(order)
    if order.waiting_payment?
      subject = "#{order.user.first_name}, recebemos seu pedido."
    elsif order.authorized?
      subject = "Seu pedido n#{order.number} foi confirmado!"
    elsif order.canceled? || order.reversed?
      if order.payment.credit_card?
        subject = "Seu pedido n#{order.number} foi cancelado."
      end
    end
  end

  def send_mail(order)
    subject = build_subject(order)
    mail(:to => order.user.email, :subject => subject)
  end
end
