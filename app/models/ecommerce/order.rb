# -*- encoding : utf-8 -*-
class Order < ActiveRecord::Base
  DEFAULT_QUANTITY = 1
  CONSTANT_NUMBER = 1782
  CONSTANT_FACTOR = 17
  WAREHOUSE_TIME = 2
  CANCELLATION_SOURCE = {:moip => 1, :abacos => 2}

  STATUS = {
    "waiting_payment" => "Aguardando pagamento",
    "under_review" => "Em revisão",
    "canceled" => "Cancelado",
    "reversed" => "Estornado",
    "refunded" => "Reembolsado",
    "delivering" => "Despachado",
    "delivered" => "Entregue",
    "not_delivered" => "Não entregue",
    "picking" => "Separando",
    "authorized" => "Pagamento autorizado"
  }

  belongs_to :user
  has_many :variants, :through => :line_items
  has_many :line_items, :dependent => :destroy
  delegate :name, :to => :user, :prefix => true
  delegate :email, :to => :user, :prefix => true
  delegate :price, :to => :freight, :prefix => true, :allow_nil => true
  delegate :delivery_time, :to => :freight, :prefix => true, :allow_nil => true
  delegate :payment_response, :to => :payment, :allow_nil => true
  has_one :payment, :dependent => :destroy
  has_one :freight, :dependent => :destroy
  has_many :order_state_transitions, :dependent => :destroy
  has_many :order_events, :dependent => :destroy
  has_one :used_coupon, :dependent => :destroy
  has_one :used_promotion, :dependent => :destroy
  has_many :moip_callbacks
  has_one :cancellation_reason, :dependent => :destroy
  after_create :generate_number
  after_create :generate_identification_code

  scope :with_payment, joins(:payment)
  scope :purchased, where("state NOT IN ('canceled', 'reversed', 'refunded', 'in_the_cart')")
  scope :paid, where("state IN ('under_review', 'picking', 'delivering', 'delivered', 'authorized')")
  scope :not_in_the_cart, where("state <> 'in_the_cart'")
  scope :with_complete_payment, joins(:payment).where("payments.state IN ('authorized','completed')")

  state_machine :initial => :in_the_cart do

    store_audit_trail

    after_transition :in_the_cart => :waiting_payment, :do => :insert_order
    after_transition :in_the_cart => :waiting_payment, :do => :send_notification_order_requested
    after_transition :in_the_cart => :waiting_payment, :do => :update_user_credit

    after_transition :waiting_payment => :authorized, :do => :confirm_payment
    after_transition :waiting_payment => :authorized, :do => :use_coupon
    after_transition :waiting_payment => :authorized, :do => :send_notification_payment_confirmed
    after_transition :waiting_payment => :authorized, :do => :add_credit_to_inviter

    after_transition :picking => :delivering, :do => :send_notification_order_shipped
    after_transition :delivering => :delivered, :do => :send_notification_order_delivered

    after_transition any => :canceled, :do => :send_notification_payment_refused
    after_transition any => :reversed, :do => :send_notification_payment_refused
    after_transition any => :canceled, :do => :reimburse_credit


    event :waiting_payment do
      transition :in_the_cart => :waiting_payment
    end

    event :authorized do
      transition :waiting_payment => :authorized
    end

    event :under_review do
      transition :authorized => :under_review
    end

    event :canceled do
      transition :waiting_payment => :canceled, :not_delivered => :canceled, :in_the_cart => :canceled
    end

    event :reversed do
      transition :under_review => :reversed
    end

    event :refunded do
      transition :under_review => :refunded
    end

    event :picking do
      transition :authorized => :picking, :under_review => :picking
    end

    event :delivering do
      transition :picking => :delivering
    end

    event :delivered do
      transition :delivering => :delivered
    end

    event :not_delivered do
      transition :delivering => :not_delivered
    end
  end

  def send_notification_payment_refused
    Resque.enqueue(Orders::NotificationPaymentRefusedWorker, self.id)
  end

  def send_notification_order_delivered
    Resque.enqueue(Orders::NotificationOrderDeliveredWorker, self.id)
  end

  def send_notification_order_shipped
    Resque.enqueue(Orders::NotificationOrderShippedWorker, self.id)
  end

  def send_notification_payment_confirmed
    Resque.enqueue(Orders::NotificationPaymentConfirmedWorker, self.id)
  end

  def send_notification_order_requested
    Resque.enqueue(Orders::NotificationOrderRequestedWorker, self.id)
  end

  def enqueue_order_status_worker
    Resque.enqueue(OrderStatusWorker, self.id) if self.payment
  end

  def confirm_payment
    order_events.create(:message => "Enqueue Abacos::ConfirmPayment")
    Resque.enqueue_in(15.minutes, Abacos::ConfirmPayment, self.number)
  end

  def insert_order
    order_events.create(:message => "Enqueue Abacos::InsertOrder")
    Resque.enqueue(Abacos::InsertOrder, self.number)
  end

  def get_current_coupon
    Coupon.lock("LOCK IN SHARE MODE").find_by_id(used_coupon.try(:coupon_id))
  end

  def invalidate_coupon
    Coupon.transaction do
      coupon = get_current_coupon
      if coupon
        coupon.decrement!(:remaining_amount, 1) unless coupon.unlimited?
      end
    end
  end

  def use_coupon
    Coupon.transaction do
      coupon = get_current_coupon
      if coupon
        coupon.increment!(:used_amount, 1)
      end
    end
  end

  def clear_gift_in_line_items
    self.reload
    line_items.each {|item| item.update_attributes(:gift => false)}
  end

  def line_items_with_flagged_gift
    clear_gift_in_line_items
    flag_second_line_item_as_gift
    reload
    line_items.ordered_by_price
  end

  def flag_second_line_item_as_gift
    second_item = line_items.ordered_by_price[1]
    second_item.update_attributes(:gift => true) if second_item
  end

  def has_one_item_flagged_as_gift?
    line_items.select {|item| item.gift?}.size == 1
  end

  def status
    STATUS[state]
  end

  def remove_unavailable_items
    unavailable_items = []
    line_items.each do |li|
      item = LineItem.lock("FOR UPDATE").find(li.id)
      unavailable_items << item unless item.variant.available_for_quantity? item.quantity
    end
    size_items = unavailable_items.size
    unavailable_items.each {|item| item.destroy}
    size_items
  end

  def add_variant(variant, quantity = Order::DEFAULT_QUANTITY)
    quantity = quantity.to_i
    if variant.available_for_quantity?(quantity)
      current_item = line_items.select { |item| item.variant == variant }.first
      if current_item
        current_item.update_attributes(:quantity => quantity)
      else
        retail_price = variant.retail_price if variant.liquidation?
        current_item =  LineItem.new(:order_id => id,
                                     :variant_id => variant.id,
                                     :quantity => quantity,
                                     :price => variant.price,
                                     :retail_price => retail_price)
        line_items << current_item
      end
      current_item
    end
  end

  def remove_variant(variant)
    current_item = line_items.select { |item| item.variant == variant }.first
    current_item.destroy if current_item
  end

  def total_with_freight
    total + (freight_price || 0)
  end

  def line_items_total
    BigDecimal.new(line_items.inject(0){|result, item| result + item.total_price}.to_s)
  end

  def credits
    result = read_attribute :credits
    result.nil? ? 0 : result
  end

  def discount_from_coupon
    if used_coupon
      used_coupon.is_percentage? ? (used_coupon.value * line_items_total) / 100 : used_coupon.value
    else
      0
    end
  end

  def discount_from_promotion
    if used_promotion
      used_promotion.discount_value
    else
      0
    end
  end

  def total
    subtotal = line_items_total - total_discount
    subtotal = Payment::MINIMUM_VALUE if subtotal < Payment::MINIMUM_VALUE
    subtotal
  end

  def total_discount
    if discount_from_coupon > 0
      credits + discount_from_coupon
    else
      credits + discount_from_promotion
    end
  end

  def generate_identification_code
    code = SecureRandom.hex(16)
    while Order.find_by_identification_code(code)
      code = SecureRandom.hex(16)
    end
    update_attributes(:identification_code => code)
  end

  def decrement_inventory_for_each_item
    ActiveRecord::Base.transaction do
      line_items.each do |item|
        variant = Variant.lock("LOCK IN SHARE MODE").find(item.variant.id)
        variant.decrement!(:inventory, item.quantity)
      end
    end
  end

  def increment_inventory_for_each_item
    ActiveRecord::Base.transaction do
      line_items.each do |item|
        variant = Variant.lock("LOCK IN SHARE MODE").find(item.variant.id)
        variant.increment!(:inventory, item.quantity)
      end
    end
  end

  def rollback_inventory
    increment_inventory_for_each_item
  end

  def installments
    payment.try(:payments) || 1
  end

  def delivery_time_for_a_shipped_order
    freight_delivery_time - WAREHOUSE_TIME
  end

  def reimburse_credit
    Credit.add(credits, user, self) if credits > 0
  end

  def add_credit_to_inviter
    Credit.add_for_inviter(user, self)
  end

  def update_user_credit
    Credit.remove(credits, user, self) if credits > 0
  end

  private

  def generate_number
    new_number = (id * CONSTANT_FACTOR) + CONSTANT_NUMBER
    update_attributes(:number => new_number)
  end
end
