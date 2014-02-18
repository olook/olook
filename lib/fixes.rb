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

  def remove_product_item_view_cache product_id
    Rails.cache.delete(CACHE_KEYS[:product_picture_image_catalog][:key] % [product_id, 1])
    puts "cache da url removido"
    p = Product.find product_id
    p.catalog_picture
    p.delete_cache
    puts "cache de view removido"
  end

  def cancel_order number
    order = Order.find_by_number number
    cancelar_pedido = Abacos::CancelarPedido.new order
    Abacos::OrderAPI.cancel_order cancelar_pedido
  end
end