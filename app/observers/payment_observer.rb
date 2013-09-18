class PaymentObserver < ActiveRecord::Observer
  observe :payment

  def self.notify_about_authorization payment
      DevAlertMailer.notify(to: 'rafael.manoel@olook.com.br', subject: "Ordem de numero #{ payment.order.number } foi autorizada")
  end
end
