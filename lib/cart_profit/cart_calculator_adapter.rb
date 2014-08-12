module CartProfit
  class CartCalculatorAdapter

    def initialize cart
      @cart_calculator = CartCalculator.new(cart)
    end

    def total(payment)
      @cart_calculator.items_total
    end

    def generate_order!(gateway, tracking=nil, payment=nil)
      user = cart.user

      order = Order.create!(
        :cart_id => cart.id,
        :user_id => user.id,
        :restricted => cart.has_gift_items?,
        :gift_wrap => cart.gift_wrap,
        :amount_discount => total_discount,
        :amount_increase => total_increase,
        :amount_paid => total(payment: payment),
        :subtotal => subtotal,
        :user_first_name => user.first_name,
        :user_last_name => user.last_name,
        :user_email => user.email,
        :user_cpf => user.reseller_without_cpf? ? user.cnpj : user.cpf,
        :gross_amount => self.gross_amount,
        :gateway => gateway,
        :tracking => tracking
      )

      order.line_items = []

      cart.items.each do |item|
        order.line_items << LineItem.new(variant_id: item.variant.id, quantity: item.quantity, price: item.price,
                      retail_price: item.retail_price, sale_price: item.product.retail_price, gift: item.gift)
      end

      freight = FreightCalculator.freight_for_zip(cart.address.zip_code, subtotal, cart.shipping_service_id)[:default_shipping]
      freight.merge!({address: cart.address})

      f = Freight.create(freight.except(:cost_for_free, :free_shipping_value))

      order.freight = f
      order.save
      order


    end

    def gateway
      case cart.payment_method
      when 'CreditCard'
        Payment::GATEWAYS[:braspag]
      when 'Billet'
        Payment::GATEWAYS[:olook]
      when 'Debit'
        Payment::GATEWAYS[:moip]
      when 'MercadoPagoPayment'
        Payment::GATEWAYS[:mercadopago]
      end
    end

    def cart
      @cart_calculator.cart
    end

    def gross_amount
      subtotal + @cart_calculator.cart_addings
    end

    def subtotal
      @cart_calculator.items_subtotal + @cart_calculator.items_discount
    end

    def total_increase
      @cart_calculator.cart_addings + @cart_calculator.freight_price
    end

    def total_discount_by_type(discount_type, payment=nil)
      case discount_type
      when (:gift)
        @cart_calculator.cart_addings || BigDecimal.new(0)
      when (:credits_by_loyalty_program)
        @cart_calculator.used_credits_value || BigDecimal.new(0)
      when (:credits_by_invite)
        BigDecimal.new(0)
      when (:credits_by_redeem)
        BigDecimal.new(0)
      when (:billet_discount)
        @cart_calculator.billet_discount || BigDecimal.new(0)
      when (:debit_discount)
        @cart_calculator.debit_discount || BigDecimal.new(0)
      when (:facebook_discount)
        BigDecimal.new(0)
      end
    end

    def total_discount
      @cart_calculator.payment_discounts + @cart_calculator.used_credits_value
    end

    def freight
      {address: {id: cart.address.id}}
    end

  end
end