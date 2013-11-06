# -*- encoding : utf-8 -*-
class MercadoPagoPayment < Payment

  def to_s
    "MercadoPago"
  end

  def human_to_s
    "Mercado Pago"
  end

  def create_preferences address
    phone = address.telephone

    items = cart.items.map do |item|
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
      'external_reference' => order.number
    }

    preference = MP.create_preference(preference_data)
    update_attribute(:url, preference['response']['sandbox_init_point'])
  end
end
