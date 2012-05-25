# -*- encoding : utf-8 -*-
class CreditService
  
  CREDIT_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/credit.yml")
  
  attr_accessor :service

  def initialize(service)
    @service = service
  end

  def create_transaction(value, operation, reason, user)
    @service.respond_to?(operation) ? @service.send(operation, BigDecimal.new(value).abs, reason, user) : false
  end

end