# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :clean_moip_callback, :class => MoipCallback do
    status_pagamento "3"
    cod_moip "3"
    tipo_pagamento "Boleto"
    classificacao "Tudo Certo"
    processed false
  end

  factory :moip_callback, :parent => :clean_moip_callback do
    association :payment, :factory => :billet
    after(:create) do |moip_callback|
      moip_callback.update_attribute(:id_transacao, moip_callback.payment.identification_code)
    end
  end

  factory :processed_moip_callback, :parent => :clean_moip_callback do
    processed true
  end

  factory :not_processed_moip_callback, :parent => :clean_moip_callback do
    processed false
  end
end
