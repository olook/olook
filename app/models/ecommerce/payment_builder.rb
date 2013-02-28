# -*- encoding : utf-8 -*-
class PaymentBuilder
  attr_accessor :cart_service, :payment, :delivery_address, :response, :gateway_strategy

  def initialize(opts = { })
    @cart_service = opts[:cart_service]
    @payment = opts[:payment]
    @gateway_strategy = opts[:gateway_strategy]
    @tracking_params = opts[:tracking_params]
  end

  def verify_payment_for(total_paid, payment_class, credit=nil)
    if should_create_payment_for?(total_paid)
      credit ? create_credit_payment(total_paid, payment_class, credit) : create_payment(total_paid, payment_class)
    end
  end

  def should_create_payment_for?(value)
    value > 0
  end

  def create_payment(total_paid, payment_class)
    current_payment = payment_class.create!(
      total_paid: total_paid,
      order: payment.order,
      user_id: payment.user_id,
      cart_id: @cart_service.cart.id)
      current_payment.calculate_percentage!
      current_payment.deliver!
      current_payment.authorize!
  end

  def create_credit_payment(total_credit, payment_class, credit)
    credit_payment = payment_class.create!(
      :credit_type_id => CreditType.find_by_code!(credit).id,
      :total_paid => total_credit,
      :order => payment.order,
      :user_id => payment.user_id,
      :cart_id => @cart_service.cart.id)
      credit_payment.calculate_percentage!
      credit_payment.deliver!
      credit_payment.authorize!
  end

  def process!
    payment.cart_id = cart_service.cart.id
    payment.total_paid = cart_service.total(payment)
    payment.user_id = cart_service.cart.user.id
    payment.save!


    ActiveRecord::Base.transaction do
      total_liquidation = cart_service.cart.total_liquidation_discount
      total_promotion = cart_service.cart.total_promotion_discount
      billet_discount = cart_service.total_discount_by_type(:billet_discount, payment)
      total_gift = cart_service.total_discount_by_type(:gift)
      total_coupon = cart_service.total_discount_by_type(:coupon)
      total_credits = cart_service.total_discount_by_type(:credits_by_loyalty_program)
      total_credits_invite = cart_service.total_discount_by_type(:credits_by_invite)
      total_credits_redeem = cart_service.total_discount_by_type(:credits_by_redeem)

      payment = @gateway_strategy.send_to_gateway

      if @gateway_strategy.payment_successful?
        tracking_order = payment.user.add_event(EventType::TRACKING, @tracking_params) if @tracking_params
        order = cart_service.generate_order!(payment.gateway, tracking_order, payment)
        payment.order = order
        payment.calculate_percentage!
        payment.deliver! if payment.kind_of?(CreditCard)
        payment.deliver! if payment.kind_of?(Debit)
        payment.save!

        order.line_items.each do |item|
          variant = Variant.lock("LOCK IN SHARE MODE").find(item.variant.id)
          variant.decrement!(:inventory, item.quantity)
        end

        verify_payment_for(total_liquidation, OlookletPayment)

        verify_payment_for(billet_discount, BilletDiscountPayment)

        verify_payment_for(total_gift, GiftPayment)

        verify_payment_for(total_coupon, CouponPayment)

        verify_payment_for(total_promotion, PromotionPayment)

        verify_payment_for(total_credits, CreditPayment, :loyalty_program )

        verify_payment_for(total_credits, CreditPayment, :invite )

        verify_payment_for(total_credits, CreditPayment, :redeem )

        respond_with_success
      else
        respond_with_failure
      end
    end

    rescue Exception => error
      ErrorNotifier.send_notifier(@gateway_strategy.class, error.message, payment)
      respond_with_failure
  end

  private

  def respond_with_failure
    OpenStruct.new(:status => Payment::FAILURE_STATUS, :payment => nil)
  end

  def respond_with_success
    OpenStruct.new(:status => Payment::SUCCESSFUL_STATUS, :payment => payment)
  end

  def log(message, logger = Rails.logger, level = :error)
    logger.send(level, message)
  end
end

