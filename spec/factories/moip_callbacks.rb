# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :clean_moip_callback, :class => MoipCallback do
    status_pagamento "3" 
    cod_moip "3"
    tipo_pagamento "Boleto"
    classificacao "Tudo Certo"
  end

  factory :moip_callback, :parent => :clean_moip_callback do
    association :payment, :factory => :billet
    
    after_create do |moip_callback|
      moip_callback.update_attribute(:id_transacao, moip_callback.payment.identification_code) 
    end    
  end
end
