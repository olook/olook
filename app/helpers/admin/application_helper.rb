module Admin::ApplicationHelper
  def payment_with_origin(payment)
    "#{payment.type}#{payment.credit_type.try{|c| '('+c.code+')' }}"
  end
end

