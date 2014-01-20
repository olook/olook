# -*- encoding : utf-8 -*-
class PaymentBuilder
  attr_accessor :cart_service, :payment, :delivery_address, :response, :gateway_strategy

  def initialize(opts = { })
    @cart_service = opts[:cart_service]
    @payment = opts[:payment]
    @gateway_strategy = opts[:gateway_strategy]
    @tracking_params = opts[:tracking_params]
    log("Initializing Payment with #{opts.inspect}")
  end

  def create_payment_for(total_paid, payment_class, opts=nil)
    if should_create_payment_for?(total_paid)
      log("Creating Payment for #{payment_class} with total_paid: #{total_paid} and options: #{opts}")
      create_payment(total_paid, payment_class, opts)
    end
  end

  def should_create_payment_for?(value)
    value > 0
  end

  def create_payment(total_paid, payment_class, opts)
    options = opts || {}

    attributes = {
      total_paid: total_paid,
      order: payment.order,
      user_id: payment.user_id,
      cart_id: @cart_service.cart.id
    }

    attributes.merge!({:source => options[:promotion]}) if options[:promotion]
    attributes.merge!({:line_item_id => options[:line_item_id]}) if options[:line_item_id]
    attributes.merge!({:credit_type_id => CreditType.find_by_code!(options[:credit]).id}) if options[:credit]
    attributes.merge!({:coupon_id => options[:coupon_id]}) if options[:coupon_id]

    current_payment = payment_class.create!(attributes)
    change_state_of(current_payment)
  end

  def process!
    payment.cart_id = cart_service.cart.id
    payment.total_paid = cart_service.total(payment)
    payment.user_id = cart_service.cart.user.id
    payment.save!
    log("Saving Payment data on payment ##{payment.try :id}")

    ActiveRecord::Base.transaction do
      total_gift = cart_service.total_discount_by_type(:gift)
      total_credits = cart_service.total_discount_by_type(:credits_by_loyalty_program)
      total_credits_invite = cart_service.total_discount_by_type(:credits_by_invite)
      total_credits_redeem = cart_service.total_discount_by_type(:credits_by_redeem)

      log("Send to Gateway: #{@gateway_strategy.class}")
      payment = @gateway_strategy.send_to_gateway
      log("Returned from Send to Gateway: #{payment.inspect}")

      if @gateway_strategy.payment_successful?
        tracking_order = payment.user.add_event(EventType::TRACKING, @tracking_params) if @tracking_params
        order = cart_service.generate_order!(payment.gateway, tracking_order, payment)
        log("Order generated: #{order.inspect}")
        payment.order = order
        payment.calculate_percentage!
        payment.deliver! if [Debit, CreditCard, MercadoPagoPayment].include?(payment.class)
        payment.save!

        notify_big_billet_sail(payment)

        order.line_items.each do |item|
          variant = Variant.lock("LOCK IN SHARE MODE").find(item.variant.id)
          variant.decrement!(:inventory, item.quantity)
        end

        # Isto está bem ruim! REFACTOR IT!!!
        log("[MERCADOPAGO] Creating preference for payment_id=#{payment.id}, sandbox_mode=#{MP.sandbox_mode} ")
        payment.create_preferences(cart_service.cart.address, cart_service.total_discount) if payment.is_a? MercadoPagoPayment
        log("[MERCADOPAGO] Preference created. Preference_url=#{payment.url}")

        create_discount_payments
        create_payment_for(total_gift, GiftPayment)
        create_payment_for(total_credits, CreditPayment, {:credit => :loyalty_program} )
        create_payment_for(total_credits_invite, CreditPayment, {:credit => :invite} )
        create_payment_for(total_credits_redeem, CreditPayment, {:credit => :redeem} )

        payment.schedule_cancellation if payment.instance_of?(Debit)

        log("Respond with_success!")
        respond_with_success
      else
        log("Respond with_failure!")
        respond_with_failure
      end
    end

    rescue Exception => error
      ErrorNotifier.send_notifier(@gateway_strategy.class, error, payment)
      respond_with_failure
  end

  private

    def create_discount_payments
      total_promotion = cart_service.cart.total_promotion_discount
      billet_discount = cart_service.total_discount_by_type(:billet_discount, payment)
      debit_discount = cart_service.total_discount_by_type(:debit_discount, payment)
      facebook_discount = cart_service.total_discount_by_type(:facebook_discount, payment)

      total_coupon = cart_service.cart.total_coupon_discount
      coupon_opts = {:coupon_id => cart_service.cart.coupon_id}
      total_liquidation = cart_service.cart.total_liquidation_discount

      create_payment_for(total_liquidation, OlookletPayment)
      create_payment_for(total_coupon, CouponPayment, coupon_opts)

      cart_service.cart.items.each do |item|
        if /Promotion:/ =~ item.cart_item_adjustment.source
          line_item = payment.order.line_items.find { |litem| litem.variant_id == item.variant_id }
          create_payment_for(item.adjustment_value, PromotionPayment, {line_item_id: line_item.try(:id), promotion: cart_service.cart.items.first.cart_item_adjustment.source})
        end
      end
      create_payment_for(total_promotion, PromotionPayment, {promotion: cart_service.cart.items.first.cart_item_adjustment.source})
      create_payment_for(facebook_discount, FacebookShareDiscountPayment)
      create_payment_for(billet_discount, BilletDiscountPayment)
      create_payment_for(debit_discount, DebitDiscountPayment)
    end


    def change_state_of(current_payment)
      current_payment.calculate_percentage!
      current_payment.deliver!
      current_payment.authorize!
    end

    def notify_big_billet_sail payment
      Resque.enqueue(NotificationWorker, {
        to: 'jenny.liu@olook.com.br, claira.zambon@olook.com.br, rafael@olook.com.br, tiago.almeida@olook.com.br',
        body: "Pedido acima de 1000 Reais: #{payment.order.number}",
        subject: "Pedido acima de mil Reais"
      }) if is_a_big_billet_sail?(payment)     
    end

    def is_a_big_billet_sail?(payment)
      payment.class == Billet && payment.total_paid > 1000
    end

    def respond_with_failure
      OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => nil, :error_code => ( @gateway_strategy.respond_to?(:return_code) ? @gateway_strategy.return_code : nil ))
    end

    def respond_with_success
      OpenStruct.new(:status => Payment::SUCCESSFUL_STATUS, :payment => payment)
    end

    def log(message, level = :info)
      Rails.logger.send(level, message)
    end
end

