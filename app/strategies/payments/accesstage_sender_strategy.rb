module Payments
  class AccesstageSenderStrategy
    include Payments::Logger

    BILLET_PAYER_TYPES = {
      pf: '1',
      pj: '2'
    }

    CALLBACK_URLS = {
      staging: "http://development.olook.com.br/cb/%%IDENTIFICATION_CODE%%",
      production: "http://www.olook.com.br/cb/%%IDENTIFICATION_CODE%%"
    }

    attr_accessor :cart_service, :payment

    def initialize(cart_service, payment)
      @cart_service, @payment = cart_service, payment
      log("Initializing AccesstageSenderStrategy [#{payment.inspect}]")
    end

    def send_to_gateway
      response = call_webservice
      @payment.url = response.authentication_url
      @payment.gateway_response_status = Payment::SUCCESSFUL_STATUS
      @payment.gateway = Payment::GATEWAYS.fetch(:accesstage)
      @payment.save!
      @payment
    end

    def payment_successful?
      true
    end

    private

    def call_webservice
      begin
        Accesstage::Service::ConnectionService.new.transaction build_billet_request(build_billet(build_payer((build_address))))
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
        type: BILLET_PAYER_TYPES[:pf], 
        id: @cart_service.cart.address.user.cpf, 
        name: @cart_service.cart.address.full_name,
        address: address
      )
    end

    def build_billet payer
      Accesstage::Model::Billet.new(bank_code: "341", payer: payer)
    end

    def build_billet_request billet
      Accesstage::Model::BilletTransactionRequest.new( 
        order_number: @payment.identification_code, 
        order_total: @payment.total_paid, 
        return_url: CALLBACK_URLS[Accesstage.configuration.environment.to_sym].gsub("%%IDENTIFICATION_CODE%%", @payment.identification_code), 
        billet: billet
      )
    end

  end
end