class ProductListener
  def self.notify_about_visibility(products, admin)
    mail = DevAlertMailer.product_visibility_notification(products, admin)
    mail.deliver
  end
end
