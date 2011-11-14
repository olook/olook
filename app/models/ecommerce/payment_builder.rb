# -*- encoding : utf-8 -*-
class PaymentBuilder
  attr_accessor :order, :payment, :delivery_address

  def initialize(order, payment, delivery_address)
    @order, @payment, @delivery_address = order, payment, delivery_address
  end

  def payer
    { :nome => order.user_name,
      :email => order.user_email,
      :logradouro => delivery_address.street,
      :complemento => delivery_address.complement,
      :numero => delivery_address.number,
      :bairro => delivery_address.neighborhood,
      :cidade => delivery_address.city,
      :estado => delivery_address.state,
      :pais => delivery_address.country,
      :cep => delivery_address.zip_code,
      :tel_fixo => delivery_address.telephone }
  end

  def payment_data
    billet = { :valor => order.total, :id_proprio => order.id,
                :forma => "BoletoBancario", :pagador => payer,
                :razao=> "Pagamento" }

    credit = { :valor => order.total, :id_proprio => order.id, :forma => "CartaoCredito",
                :instituicao => "Visa",:numero => "4220612351354111",
                :expiracao => "08/11", :codigo_seguranca => "192",
                :nome => "Rinaldi Fonseca Nascimento", :identidade => "134.277.017.00",
                :telefone => "(21)9208-0547", :data_nascimento => "25/10/1980",
                :parcelas => "1", :recebimento => "AVista",
                :pagador => payer, :razao => "Pagamento" }

     debit = { :valor => order.total, :id_proprio => order.id, :forma => "DebitoBancario",
               :instituicao => "BancoDoBrasil", :pagador => payer,
               :razao => "Pagamento" }

     data = case payment.payment_type
       when Payment::TYPE[:billet] then billet
       when Payment::TYPE[:debit]  then debit
       else credit
     end
  end
end
