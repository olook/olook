# -*- encoding : utf-8 -*-
class Order < ActiveRecord::Base
  CONSTANT_NUMBER = 1782
  CONSTANT_FACTOR = 17
  WAREHOUSE_TIME = 2

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

  belongs_to :cart
  belongs_to :user

  has_many :variants, :through => :line_items
  has_one :payment, :dependent => :destroy
  has_one :freight, :dependent => :destroy
  has_many :order_state_transitions, :dependent => :destroy
  has_many :order_events, :dependent => :destroy
  has_one :used_coupon, :dependent => :destroy
  has_one :used_promotion, :dependent => :destroy
  has_many :moip_callbacks
  has_many :line_items, :dependent => :destroy
  alias :items :line_items

  after_create :initialize_order

  delegate :price, :to => :freight, :prefix => true, :allow_nil => true
  delegate :city, :to => :freight, :prefix => true, :allow_nil => true
  delegate :state, :to => :freight, :prefix => true, :allow_nil => true
  delegate :delivery_time, :to => :freight, :prefix => true, :allow_nil => true
  delegate :payment_response, :to => :payment, :allow_nil => true

  def self.with_payment
    joins(:payment)
  end

  def self.purchased
    where("state NOT IN ('canceled', 'reversed', 'refunded')")
  end

  def self.paid
     where("state IN ('under_review', 'picking', 'delivering', 'delivered', 'authorized')")
  end

  def self.with_complete_payment
    joins(:payment).where("payments.state IN ('authorized','completed')")
  end


  state_machine :initial => :waiting_payment do

    store_audit_trail

    after_transition :waiting_payment => :authorized, :do => :confirm_payment
    after_transition :waiting_payment => :authorized, :do => :use_coupon
    after_transition :waiting_payment => :authorized, :do => :send_notification_payment_confirmed
    after_transition :waiting_payment => :authorized, :do => :add_credit_to_inviter

    after_transition :picking => :delivering, :do => :send_notification_order_shipped
    after_transition :delivering => :delivered, :do => :send_notification_order_delivered

    after_transition any => :canceled, :do => :send_notification_payment_refused
    after_transition any => :reversed, :do => :send_notification_payment_refused
    after_transition any => :canceled, :do => :reimburse_credit

    event :authorized do
      transition :waiting_payment => :authorized
    end

    event :under_review do
      transition :authorized => :under_review
    end

    event :canceled do
      transition :waiting_payment => :canceled, :not_delivered => :canceled
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

  def notify_sac_for_fraud_analysis
    # SAC::Notifier.notify(SAC::Notification.new(:fraud_analysis, "Análise de Fraude | Pedido : #{self.number}", self))
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
    Resque.enqueue_in(20.minutes, Abacos::ConfirmPayment, self.number)
  end

  def insert_order
    self.update_attribute(:purchased_at, Time.now)
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

  def credits
    credit = read_attribute :credits
    credit.nil? ? 0 : credit
  end

  def reimburse_credit
    Credit.add(credits, user, self) if credits > 0
  end

  def add_credit_to_inviter
    Credit.add_for_inviter(user, self)
    # UserCredit.add_for_inviter(self)
  end

  def update_user_credit
    Credit.remove(credits, user, self) if credits > 0
  end

  def user_name
    "#{user_first_name} #{user_last_name}".strip
  end
  
  private

  def initialize_order
    generate_number
    self.generate_identification_code
    self.insert_order
    self.send_notification_order_requested
    self.update_user_credit
    self.notify_sac_for_fraud_analysis
  end

  def generate_number
    new_number = (id * CONSTANT_FACTOR) + CONSTANT_NUMBER
    update_attributes(:number => new_number)
  end
end
