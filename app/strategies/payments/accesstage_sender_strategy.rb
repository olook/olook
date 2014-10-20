module Payments
  class AccesstageSenderStrategy
    include Payments::Logger

    BILLET_CALLBACK_URLS = {
      staging: "http://development.olook.com.br/cb/b/%%IDENTIFICATION_CODE%%",
      production: "http://www.olook.com.br/cb/b/%%IDENTIFICATION_CODE%%"
    }

    BILLET_BANK_CODE = "341" #ITAU

    DEBIT_CALLBACK_URLS = {
      staging: "http://development.olook.com.br/cb/d/%%PAYMENT_ID%%",
      production: "http://www.olook.com.br/cb/d/%%PAYMENT_ID%%"
    }

    attr_accessor :cart_service, :payment

    def initialize(cart_service, payment)
      @cart_service, @payment = cart_service, payment
      log("Initializing AccesstageSenderStrategy [#{payment.inspect}]")
    end

    def send_to_gateway
      return send_billet_to_gateway if @payment.is_a? Billet
      return send_debit_to_gateway if @payment.is_a? Debit
    end

    def payment_successful?
      true
    end

    private

    def call_webservice request_hash
      begin
        Accesstage::Service::ConnectionService.new.transaction request_hash
      rescue Exception => error
        log("[ERROR] Error on processing enqueued request: " + error.message)
        ErrorNotifier.send_notifier("Accesstage", error, payment)
        OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => payment)
        raise error
      end        
    end

    def build_address
      Accesstage::Model::Address.new(
        postal_code: @cart_service.cart.address.zip_code.gsub("-",""), 
        neighborhood: @cart_service.cart.address.neighborhood, 
        city: @cart_service.cart.address.city, 
        state: @cart_service.cart.address.state, 
        address: [@cart_service.cart.address.street, @cart_service.cart.address.number.to_s, @cart_service.cart.address.complement].join(', ')
      )
    end

    def build_payer address
      Accesstage::Model::Payer.new(
        type:  Accesstage::Model::Payer::TYPES[:pf], 
        id: @cart_service.cart.address.user.cpf, 
        name: @cart_service.cart.address.full_name,
        address: address
      )
    end

    def build_billet payer
      Accesstage::Model::Billet.new(bank_code: BILLET_BANK_CODE, payer: payer)
    end

    def build_billet_request billet
      Accesstage::Model::BilletTransactionRequest.new( 
        order_number: @payment.identification_code, 
        order_total: @payment.total_paid.round(2), 
        return_url: BILLET_CALLBACK_URLS[Accesstage.configuration.environment.to_sym].gsub("%%IDENTIFICATION_CODE%%", @payment.identification_code), 
        billet: billet
      )
    end

    def build_debit_request bank
      Accesstage::Model::DebitTransactionRequest.new( 
        order_number: @payment.id, 
        order_total: @payment.total_paid.round(2), 
        return_url: DEBIT_CALLBACK_URLS[Accesstage.configuration.environment.to_sym].gsub("%%PAYMENT_ID%%", @payment.id.to_s), 
        acquirer: Accesstage::Model::DebitTransactionRequest::ACQUIRERS[bank], 
      )
    end

    def send_billet_to_gateway
      response = call_webservice(build_billet_request(build_billet(build_payer((build_address)))))
      update_payment response
    end

    def send_debit_to_gateway
      response = call_webservice(build_debit_request(bank))
      update_payment response
    end

    def update_payment response
      @payment.url = response.authentication_url
      @payment.gateway_response_status = Payment::SUCCESSFUL_STATUS
      @payment.state = :waiting_payment      
      @payment.gateway = Payment::GATEWAYS.fetch(:accesstage)
      @payment.save!
      @payment      
    end

    def bank
      @payment.bank.downcase.to_sym
    end

  end
end