module Payments
  class BraspagSenderStrategy
    FILE_DIR = "#{Rails.root}/config/braspag.yml"

    attr_accessor :cart_service, :payment, :credit_card_number, :response

    def initialize(cart_service, payment)
      @cart_service, @payment = cart_service, payment
    end

    def send_to_gateway  
      begin
        set_payment_gateway
        Resque.enqueue(Braspag::GatewaySenderWorker, payment.id)      
        payment
      rescue Exception => error
        ErrorNotifier.send_notifier("Braspag", error.message, payment)
        OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => nil)
      end
    end

    def payment_successful?
      true
    end

    def set_payment_gateway
      payment.gateway = Payment::GATEWAYS.fetch(:braspag)
    end    
  end
end
