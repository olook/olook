# -*- encoding : utf-8 -*-
class BilletGenerator
  attr_accessor :billets

  def initialize(billets)
    @billets = billets
  end

  def generate(builder = PaymentBuilder)
    count = 0
    billets.each do |billet|
      order = billet.order
      if order
        unless billet.payment_expiration_date
          order.generate_identification_code
          billet.payment_response.destroy if billet.payment_response
          payment_builder = builder.new(order, billet)
          response = payment_builder.process!(false)
          if response.status == Payment::SUCCESSFUL_STATUS
            billet.set_payment_expiration_date
            count += 1
            puts "Link #{billet.url} - Order: #{order.number} - Nome #{order.user.first_name}"
          else
            puts "Erro no processamento: Boleto #{billet.id} - Order: #{order.number}"
          end
        end
      else
        puts "O Boleto #{billet.id} não possui uma ordem"
      end
    end
    count
  end
end
