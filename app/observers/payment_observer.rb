class PaymentObserver < ActiveRecord::Observer
  observe :payment

  def self.notify_about_authorization payment
    DevAlertMailer.notify(to: "vinicius.monteiro@olook.com.br", subject: "Ordem de numero #{ payment.order.number } foi autorizada").deliver
  end
end
