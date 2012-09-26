# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Checkout::PaymentsController do
  let(:payment) { FactoryGirl.create(:billet) }
  let(:status_pagamento) { "3" }
  let(:cod_moip) { "3" }
  let(:tipo_pagamento) { "CartaoDeCredito" }
  let(:classificacao) { "TUDO CERTO" }
  let(:params) { 
    {
      status_pagamento: status_pagamento, 
      cod_moip:         cod_moip, 
      tipo_pagamento:   tipo_pagamento,
      classificacao:    classificacao
    }
  }
  
  it "should create moip callback with invalid payment" do
    post :create, params.merge(id_transacao: "XPTO")
    moip_callback = MoipCallback.last
    moip_callback.cod_moip.should eq(cod_moip)
    moip_callback.tipo_pagamento.should eq(tipo_pagamento)
    moip_callback.status_pagamento.should eq(status_pagamento)
    moip_callback.id_transacao.should eq("XPTO")
    moip_callback.classificacao.should eq(classificacao)
    moip_callback.payment_id.should eq(nil)
  end
  
  it "should create moip callback with valid payment" do
    post :create, params.merge(id_transacao: payment.identification_code)
    moip_callback = MoipCallback.last
    moip_callback.cod_moip.should eq(cod_moip)
    moip_callback.tipo_pagamento.should eq(tipo_pagamento)
    moip_callback.status_pagamento.should eq(status_pagamento)
    moip_callback.id_transacao.should eq(payment.identification_code)
    moip_callback.classificacao.should eq(classificacao)
    moip_callback.payment_id.should eq(payment.id)
  end
  
  it "should response 200 when ok" do
    post :create, params
    response.success?.should eq(true)
  end
end
