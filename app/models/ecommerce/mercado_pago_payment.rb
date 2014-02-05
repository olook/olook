# -*- encoding : utf-8 -*-
class MercadoPagoPayment < Payment
  before_create :set_payment_expiration_date

  def to_s
    "MercadoPago"
  end

  def human_to_s
    "Mercado Pago"
  end

  # 
  # Por enquanto utiliza a mesma regra de expiração de boleto
  # 
  def build_payment_expiration_date
    BilletExpirationDate.expiration_for_two_business_day
  end

  def self.to_expire
    expiration_date = 1.business_day.before(Time.zone.now) - 1.day
    self.where(payment_expiration_date: expiration_date.beginning_of_day..expiration_date.end_of_day, state: ["waiting_payment", "started"])
  end  

  def create_preferences address, total_credits_value
    phone = address.telephone

    items = cart.items.select{|i| i.retail_price.to_f > 0}.map do |item|
      {
        'id' => item.id,
        'title' => item.name,
        'quantity' => item.quantity,
        'currency_id' => 'BRL',
        'unit_price' => item.retail_price.to_f,
        'category_id' => 'fashion',
        'picture_url' => 'http:' + item.product.main_picture.image_url(:catalog)
      }
    end

    # descontos (fidelidade, reembolso, facebook)
    if total_credits_value.to_f > 0
      items << {
          'id' => 10,
          'title' => "CREDITOS",
          'quantity' => 1,
          'currency_id' => 'BRL',
          'unit_price' => (total_credits_value * (-1)).to_f,
          'category_id' => 'fashion'
      }      
    end

    # frete
    if order.freight.price.to_f > 0
      items << {
          'id' => 10,
          'title' => "FRETE",
          'quantity' => 1,
          'currency_id' => 'BRL',
          'unit_price' => order.freight.price.to_f,
          'category_id' => 'fashion'
      }
    end

    preference_data = {
      'items' => items,
      'payer' => {
        'name' => user.first_name,
        'surname' => user.last_name,
        'email' => user.email,
        'date_created' => user.created_at.iso8601(3),
        'phone' => {
          'area_code'=> phone[1..2],
          'number'=> phone[4..phone.size]
        },
        'identification'=> {
          'type'=> 'CPF',
          'number'=> user.cpf
        },
        
        'address' => {
          'street_name' => address.street,
          'street_number' => address.number,
          'zip_code' => address.zip_code 
          }
      },
      'shipments' => {
        'receiver_address' => {
          'zip_code' => address.zip_code,
          'street_number' => address.number,
          'street_name' => address.street,
          'apartment' => address.complement
        }
      },
      'external_reference' => order.number,
      'payment_methods' => {
        'installments' => 6
      },
      'payment_methods' => { 
        'excluded_payment_types' => [ { "id" => "ticket" } ] 
      }
    }

    begin
      Rails.logger.info("[MERCADOPAGO] Creating preference. preference_data=#{preference_data.inspect}")
      preference = MP.create_preference(preference_data)
      Rails.logger.info("[MERCADOPAGO] preference created=#{preference.inspect}")
      update_attribute(:url, preference['response'][MP.init_point])
    rescue => e
      Rails.logger.info("[MERCADOPAGO] Error creating preference: #{e}")
      raise e
    end
  end
end
