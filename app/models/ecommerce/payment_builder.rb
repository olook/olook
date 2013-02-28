# -*- encoding : utf-8 -*-
class PaymentBuilder
  attr_accessor :cart_service, :payment, :delivery_address, :response, :gateway_strategy

  def initialize(opts = { })
    @cart_service = opts[:cart_service]
    @payment = opts[:payment]
    @gateway_strategy = opts[:gateway_strategy]
    @tracking_params = opts[:tracking_params]
  end

  def verify_payment_for(total_paid, payment_class)
    create_payment(total_paid, payment_class) if should_create_payment_for?(total_paid)
  end

  def should_create_payment_for?(value)
    value > 0
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


        if total_credits > 0
          credit_payment = CreditPayment.create!(
            :credit_type_id => CreditType.find_by_code!(:loyalty_program).id,
            :total_paid => total_credits,
            :order => order,
            :user_id => payment.user_id,
            :cart_id => @cart_service.cart.id)
          credit_payment.calculate_percentage!
          credit_payment.deliver!
          credit_payment.authorize!
        end

        if total_credits_invite > 0
          credit_payment_invite = CreditPayment.create!(
            :credit_type_id => CreditType.find_by_code!(:invite).id,
            :total_paid => total_credits_invite,
            :order => order,
            :user_id => payment.user_id,
            :cart_id => @cart_service.cart.id)
          credit_payment_invite.calculate_percentage!
          credit_payment_invite.deliver!
          credit_payment_invite.authorize!
        end

        if total_credits_redeem > 0
          credit_payment_redeem = CreditPayment.create!(
            :credit_type_id => CreditType.find_by_code!(:redeem).id,
            :total_paid => total_credits_redeem,
            :order => order,
            :user_id => payment.user_id,
            :cart_id => @cart_service.cart.id)
          credit_payment_redeem.calculate_percentage!
          credit_payment_redeem.deliver!
          credit_payment_redeem.authorize!
        end
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

  def create_payment(payment_class, total_paid)
    current_payment = payment_class.create!(
      total_paid: total_paid,
      order: payment.order,
      user_id: payment.user_id,
      cart_id: @cart_service.cart.id)
      current_payment.calculate_percentage!
      current_payment.deliver!
      current_payment.authorize!
  end

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

