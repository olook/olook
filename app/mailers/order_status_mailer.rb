# -*- encoding : utf-8 -*-
class OrderStatusMailer < ActionMailer::Base
  default_url_options[:host] = "www.olook.com.br"
  default :from => "olook <avisos@o.olook.com.br>"

  def self.smtp_settings
    {
      :user_name => "olook",
      :password => "olook123abc",
      :domain => "my.olookmail.com.br",
      :address => "smtp.sendgrid.net",
      :port => 587,
      :authentication => :plain,
      tls: true,
      enable_starttls_auto: true
    }
  end

  [:order_requested, :payment_confirmed, :payment_refused, :order_delivered].each do |method|
    define_method method do |order|
      @order = order
      send_mail(@order)
    end
  end

  private

  def build_subject(order)
    if order.waiting_payment?
      subject = "#{order.user.first_name}, recebemos seu pedido."
    elsif order.completed?
      subject = "Seu pedido #{order.number} foi confirmado!"
    elsif order.canceled? || order.reversed?
      subject = "Seu pedido #{order.number} foi cancelado."
    elsif order.delivered?
      subject = "Seu pedido #{order.number} foi entregue."
    end
  end

  def send_mail(order)
    subject = build_subject(order)
    mail(:to => order.user.email, :subject => subject)
  end
end
