# -*- encoding : utf-8 -*-
class OrderStatusMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "olook <avisos@olook.com.br>"

  def self.smtp_settings
    {
      :user_name => "AKIAJJO4CTAEHYW34HGQ",
      :password => "AkYlOmgbIpISW33XVzQq8d9J4GnAgtQlEJuwgIxOFXmU",
      :address => "email-smtp.us-east-1.amazonaws.com",
      :port => 587,
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  end

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
        subject = "Lembrete: seu boleto expira em: #{order.get_billet_expiration_date.strftime("%d/%m/%Y")}. Garanta seu pedido!"
      else
        subject = "#{order.user.first_name}, recebemos seu pedido."
      end
    elsif order.authorized?
      subject = "Seu pedido n#{order.number} foi confirmado!"
    elsif order.delivering?
      subject = "Seu pedido n#{order.number} foi enviado!"
    elsif order.delivered?
      subject = "Seu pedido n#{order.number} foi entregue!"
    elsif order.canceled? || order.reversed?
      subject = "Seu pedido n#{order.number} foi cancelado."
    end
  end

  def send_mail(order)
    subject = build_subject(order)
    mail(:to => order.user.email, :subject => subject)
  end
end
