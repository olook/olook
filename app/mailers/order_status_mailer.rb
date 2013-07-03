# -*- encoding : utf-8 -*-
class OrderStatusMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "Equipe Olook <avisos@olook.com.br>"

  [:order_requested, :payment_confirmed, :payment_refused, :order_shipped, :order_delivered].each do |method|
    define_method method do |order|
      @order = order
      send_mail(@order)
    end
  end

  private

  def build_subject(order)
    if order.waiting_payment?
      if order.has_a_billet_payment?
        subject = "Lembrete: seu boleto expira em: #{I18n.l(order.get_billet_expiration_date, format: "%d/%m/%Y")}. Garanta seu pedido!"
      else
        subject = "#{order.user.first_name}, recebemos seu pedido."
      end
    elsif order.authorized?
      subject = "#{order.user.first_name}, seu pedido nº #{order.number} foi confirmado!"
    elsif order.delivering?
      subject = "#{order.user.first_name}, seu pedido nº #{order.number} foi enviado!"
    elsif order.delivered?
      subject = "#{order.user.first_name}, seu pedido nº #{order.number} foi entregue!"
    elsif order.canceled? || order.reversed?
      subject = "#{order.user.first_name}, seu pedido nº #{order.number} foi cancelado."
    end
  end

  def send_mail(order)
    subject = build_subject(order)
    mail(:to => order.user.email, :subject => subject)
  end
end
