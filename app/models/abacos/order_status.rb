# -*- encoding : utf-8 -*-
module Abacos
  class OrderStatus
    extend ::Abacos::Helpers

    attr_reader :integration_protocol, :order_number, :new_state,
                :datetime, :invoice, :invoice_datetime, :tracking_code,
                :cancelation_reason
                
    VALID_STATES = ['authorized', 'picking', 'delivering', 'delivered']

    def initialize(parsed_data)
      parsed_data.each do |key, value|
        self.instance_variable_set "@#{key}", value
      end
    end

    def integrate
      order = find_and_check_order self.order_number
      change_order_state order
      confirm_order_status
    end
    
    def self.parse_abacos_data(abacos_status)
      { integration_protocol: abacos_status[:protocolo_status_pedido],
        order_number:         abacos_status[:numero_pedido],
        new_state:            parse_status(abacos_status[:codigo_status]),
        datetime:             parse_datetime(abacos_status[:data_hora]),
        invoice:              parse_invoice(abacos_status[:serie_nota], abacos_status[:numero_nota]),
        invoice_datetime:     parse_datetime(abacos_status[:data_emissao_nota]),
        tracking_code:        abacos_status[:numero_objeto],
        cancelation_reason:   parse_cancelation(abacos_status[:codigo_motivo_cancelamento], abacos_status[:motivo_cancelamento])
      }
    end
    
    private
    
    def self.parse_status(abacos_status)
      case abacos_status
        when '01' then :picking
        when '02' then :picking
        when '03' then :canceled
        when '04' then :delivering
        when '05' then :delivered
      end
    end
    
    def self.parse_datetime(abacos_datetime)
      format = /(\d{2})(\d{2})(\d{4}) (\d{2}):(\d{2}):(\d{2}).\d{3}/
      parsed = abacos_datetime.try :match, format
      if parsed
        DateTime.civil parsed[3].to_i, parsed[2].to_i, parsed[1].to_i, parsed[4].to_i, parsed[5].to_i, parsed[6].to_i
      else
        nil
      end
    end
    
    def self.parse_invoice(series, number)
      "SÉRIE #{series} - NÚMERO #{number}"
    end
    
    def self.parse_cancelation(code, reason)
      "#{code} - #{reason}"
    end

    def find_and_check_order(number)
      order = Order.find_by_number number
      raise "Order number #{order_number} doesn't exist" unless order
      raise "Order number #{order.number} state is #{order.state}, which is invalid for integration" unless VALID_STATES.include?(order.state)
      order
    end
    
    def confirm_order_status
      Resque.enqueue Abacos::ConfirmOrderStatus, self.integration_protocol
    end
    
    def change_order_state(order)
      next_index = VALID_STATES.index(order.state) + 1
      new_index  = VALID_STATES.index(new_state.to_s)

      VALID_STATES[next_index..new_index].each do |s|
        order.send s.to_sym
      end
    end
  end
end
