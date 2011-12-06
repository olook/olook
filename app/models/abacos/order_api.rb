# -*- encoding : utf-8 -*-
module Abacos
  class OrderAPI
    extend Helpers

    @queue = :abacos

    def self.wsdl
      "http://erp-db.olook.com.br:8043/AbacosWebSvc/AbacosWSPedidos.asmx?wsdl"
    end
  end
end
