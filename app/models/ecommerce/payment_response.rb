class PaymentResponse < ActiveRecord::Base
  belongs_to :payment

  def build_attributes(response)
    write_attribute(:response_id, response["ID"])
    write_attribute(:response_status, response["Status"])
    write_attribute(:token, response["Token"])
    if response["RespostaPagamentoDireto"]
      write_attribute(:total_paid, response["RespostaPagamentoDireto"]["TotalPago"])
      write_attribute(:gateway_fee, response["RespostaPagamentoDireto"]["TaxaMoIP"])
      write_attribute(:gateway_code, response["RespostaPagamentoDireto"]["CodigoMoIP"])
      write_attribute(:transaction_status, response["RespostaPagamentoDireto"]["Status"])
      write_attribute(:message, response["RespostaPagamentoDireto"]["Mensagem"])
      write_attribute(:transaction_code, response["RespostaPagamentoDireto"]["CodigoAutorizacao"])
      write_attribute(:return_code, response["RespostaPagamentoDireto"]["CodigoAutorizacao"])
    end
  end
end
