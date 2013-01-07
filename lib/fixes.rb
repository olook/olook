# -*- encoding : utf-8 -*-
module Fixes

  def integrate order_number
    o = Order.find_by_number order_number
    o.amount_discount -= 0.10
    o.save
    o.freight.price -= 0.10
    o.freight.save
    Abacos::InsertOrder.perform order_number
    puts "Pedido #{order_number} integrado com sucesso!"
  end

end