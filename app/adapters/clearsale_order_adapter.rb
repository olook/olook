class ClearsaleOrderAdapter
  attr_accessor :payment, :credit_card_number, :paid_at, :created_at

  def initialize(payment, credit_card_number, paid_at, created_at = Time.current)
    @payment = payment
    @credit_card_number = credit_card_number
    @paid_at = paid_at
    @created_at = created_at
  end

  def adapt
    return adapt_order, adapt_payment, adapt_user    
  end

  def adapt_order
    {
      :id => @payment.order.id,
      :paid_at => @paid_at,
      :billing_address => adapt_address,
      :shipping_address => adapt_address,
      :installments => @payment.order.installments,
      :total_items => @payment.order.cart.items.sum{|item| item.variant.product.retail_price},
      :total_order => @payment.total_paid,
      :items_count => @payment.order.cart.items.count,
      :created_at => @created_at,
      :order_items => adapt_order_items
    }    
  end

  def adapt_order_items
    response = []

    @payment.order.cart.items.each do |item|
      hash = {
        :product => {
          :id => item.variant.number,
          :name => item.variant.name,
          :category => {
            :id => item.variant.product.category,
            :name => item.variant.product.category_humanize 
          }
        },
       :price => item.variant.product.retail_price,
       :quantity => item.quantity,
      }
      response << hash
    end

    response
  end

  def adapt_address
    address = @payment.order.freight.address
    {
      :street_name => address.street,
      :number => address.number.to_s,
      :complement => address.complement,
      :neighborhood => address.neighborhood,
      :city => address.city,
      :state => address.state,
      :postal_code => address.zip_code
    }    
  end

  def adapt_payment
    {
      :card_holder => @payment.user_name,
      :card_number => @credit_card_number,
      :card_expiration => @payment.expiration_date,
      :card_security_code => @payment.security_code,
      :acquirer => @payment.bank.downcase,
      :amount => @payment.total_paid,
    }    
  end

  def adapt_user
    {
      :email     => @payment.order.user.email,
      :id        => @payment.order.user.id,
      :cpf       => @payment.order.user.cpf,
      :full_name => @payment.order.user.name,
      :birthdate => @payment.order.user.birthdate,
      :phone     => @payment.telephone,
      :gender    => (@payment.order.user.gender ? @payment.order.user.gender : 'f'),
      :last_sign_in_ip => @payment.order.user.last_sign_in_ip
    }    
  end

end