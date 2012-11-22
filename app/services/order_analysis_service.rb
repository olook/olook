# -*- encoding : utf-8 -*-
class OrderAnalysisService

  attr_accessor :payment, :credit_card_number, :paid_at

  def initialize(payment, credit_card_number, paid_at)
    self.payment = payment
    self.credit_card_number = credit_card_number
  end

  def self.check_results(order)
    response = nil
    clearsale_response = Clearsale::Analysis.get_order_status(order.id)
    clearsale_response.status
    order.clearsale_order_responses.each{|r| r.update_attribute("processed", true)}
    response = ClearsaleOrderResponses.new(clearsale_response.order_id, clearsale_response.status, clearsale_response.score)
    response.save
    response
  end

  def self.clearsale_response_accepted?(clearsale_response)
    !ClearsaleOrderResponse.STATES_TO_BE_PROCESSED.include?(clearsale_response.status.to_sym)
  end

  def send_to_analysis
    response = nil
    clearsale_response = Clearsale::Analysis.send_order(adapt_order, adapt_payment, adapt_user)
    response = ClearsaleOrderResponses.new(clearsale_response.order_id, clearsale_response.status, clearsale_response.score)
    response.save
    response
  end
 
  def should_send_to_analysis?
    true
  end

  def adapt_order
    {
      :id => self.order.id,
      :paid_at => self.paid_at,
      :billing_address => adapt_address,
      :shipping_address => adapt_address,
      :installments => self.payment.installments,
      :total_items => self.order.cart.items.sum{|item| item.variant.product.retail_price},
      :total_order => self.payment.total_paid,
      :items_count => self.order.cart.items.count,
      :created_at => Time.current,
      :order_items => adapt_order_items
    }    
  end

  def adapt_order_items
    response = []

    self.order.cart.items.each do |item|
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
  end

  def adapt_address
    address = self.payment.order.freight.address
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
      :card_holder => self.payment.user_name,
      :card_number => self.credit_card_number,
      :card_expiration => self.payment.expiration_date,
      :card_security_code => self.payment.security_code,
      :acquirer => self.payment.bank.downcase,
      :amount => self.payment.total_paid,
    }    
  end

  def adapt_user
    {
      :email     => self.user.email,
      :id        => self.user.id,
      :cpf       => self.user.cpf,
      :full_name => self.user.name,
      :birthdate => self.user.birthday,
      :phone     => self.payment.telephone,
      :gender    => (self.user.gender ? self.user.gender : 'f'),
      :last_sign_in_ip => self.user.last_sign_in_ip
    }    
  end

end