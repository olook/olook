# -*- encoding : utf-8 -*-
class CreditService
  
  CREDIT_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/credit.yml")
  OPERATION = [:add_credit, :remove_credit]
  
  def initialize(service)
    @service = service
  end

  def create_transaction(value, operation, reason, user)
    @service.send(operation, BigDecimal.new(value).abs, reason, user)
  end

end