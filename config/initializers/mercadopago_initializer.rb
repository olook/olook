# -*- encoding : utf-8 -*-
MERCADOPAGO_CONFIG = YAML.load_file("#{Rails.root}/config/mercado_pago.yml")[Rails.env]
MP = MercadoPago.new(MERCADOPAGO_CONFIG['client_id'], MERCADOPAGO_CONFIG['client_secret'])

MP.sandbox_mode(true) unless Rails.env.production?