# -*- encoding : utf-8 -*-
module Abacos
  class ClientAPI
    extend Helpers

    @queue = :abacos
    
    def self.wsdl
      "http://erp-db.olook.com.br:8043/AbacosWebSvc/AbacosWSClientes.asmx?wsdl"
    end
  end
end
