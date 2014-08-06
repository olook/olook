module CartProfit
  class CartCalculator
    attr_reader :cart

    def initialize cart
      @cart = cart
    end

    def items_subtotal
      return 0 if cart.nil? || (cart && cart.items.nil?)
      cart.items.inject(0){|sum,item| sum += item.price * item.quantity}
    end

    def subtotal
      items_subtotal + gift_price
    end

    def items_discount
      return 0 if cart.nil? || (cart && cart.items.nil?)
      final_price = cart.items.inject(0){|sum,item| sum += item.retail_price * item.quantity}
      final_price - items_subtotal
    end

    def used_credits_value
      (cart.use_credits && cart.allow_credit_payment?) ? total_loyalty_user_credits_value : BigDecimal.new(0)
    end

    def total_loyalty_user_credits_value
      cart.user.user_credits_for(:loyalty_program).total if cart.user
    end

    def cart_addings
      gift_price
    end

    def items_total
      return 0 if cart.nil? || (cart && cart.items.nil?)
      _subtotal = subtotal + items_discount
      _subtotal -= used_credits_value
      _subtotal -= payment_discounts
    end

    def payment_discounts
      BigDecimal(billet_discount||"") + BigDecimal(debit_discount||"")
    end

    # Valor para calcular o desconto de pagamento (Debito e Boleto)
    # Qualquer valor que não queremos que incida no desconto
    # deve ser adicionado aqui.
    def retail_value
      items_subtotal + items_discount + gift_price - used_credits_value
    end

    def billet_discount
      if @cart.payment_method == "Billet" && Setting.billet_discount_available
        billet_discount_value = calculate_billet_discount_value(retail_value)
        billet_discount_value = retail_value if billet_discount_value > retail_value
        billet_discount_value
      end
    end

    def debit_discount
      if @cart.payment_method == "Debit" && Setting.debit_discount_available
        debit_discount_value = calculate_debit_discount_value(retail_value)
        debit_discount_value = retail_value if debit_discount_value > retail_value
        debit_discount_value
      end
    end

    def minimum_value
      return 0.0 if freight_price.to_f > Payment::MINIMUM_VALUE
      Payment::MINIMUM_VALUE
    end

    def freight_price
      if @cart.selected_freight
        @cart.selected_freight['price']
      end
    end

    private

    def gift_price
      cart.increment_from_gift_wrap || BigDecimal.new(0)
    end

    def calculate_debit_discount_value retail_value
      debit_discount_percent = (Setting.debit_discount_percent.to_i / 100.0).to_d
      debit_discount_value = (retail_value.to_d + minimum_value.to_d) * debit_discount_percent
      debit_discount_value.round(2, BigDecimal::ROUND_HALF_UP)
    end

    def calculate_billet_discount_value retail_value
      billet_discount_percent = (Setting.billet_discount_percent.to_i / 100.0).to_d
      billet_discount_value = (retail_value.to_d + minimum_value.to_d) * billet_discount_percent
      billet_discount_value.round(2, BigDecimal::ROUND_HALF_UP)
    end
  end
end
