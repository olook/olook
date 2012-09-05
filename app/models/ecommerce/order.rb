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
  has_many :payments, :dependent => :destroy
  has_one :freight, :dependent => :destroy
  has_many :order_state_transitions, :dependent => :destroy
  #has_one :used_coupon, :dependent => :destroy
  # has_one :used_promotion, :dependent => :destroy
  has_many :moip_callbacks
  has_many :line_items, :dependent => :destroy
  
  after_create :initialize_order

  delegate :price, :to => :freight, :prefix => true, :allow_nil => true
  delegate :city, :to => :freight, :prefix => true, :allow_nil => true
  delegate :state, :to => :freight, :prefix => true, :allow_nil => true
  delegate :delivery_time, :to => :freight, :prefix => true, :allow_nil => true

  def self.with_payment
    joins(:payments)
  end

  def self.purchased
    where("orders.state NOT IN ('canceled', 'reversed', 'refunded')")
  end

  def self.paid
     where("orders.state IN ('under_review', 'picking', 'delivering', 'delivered', 'authorized')")
  end

  def self.payments_with_discount
    paid.joins('join payments on payments.order_id = orders.id and payments.type in ("CreditPayment","CouponPayment", "OlookletPayment", "GiftPayment")')
  end

  def self.with_complete_payment
    joins(:payments).where("payments.state IN ('authorized','completed')")
  end

  state_machine :initial => :waiting_payment do

    store_audit_trail

    event :authorized do
      transition :waiting_payment => :authorized, :if => :confirm_payment?
      transition :waiting_payment => :waiting_payment
      transition :under_review => :authorized, :if => :confirm_payment?
    end

    event :under_review do
      transition :waiting_payment => :under_review
      transition :authorized => :under_review
    end

    event :canceled do
      transition :waiting_payment => :canceled, :if => :cancel_order?
      transition :not_delivered => :canceled, :if => :cancel_order?
    end

    event :reversed do
      transition :under_review => :reversed, :if => :refused_order?
    end

    event :refunded do
      transition :under_review => :refunded, :if => :refused_order?
    end

    event :picking do
      transition :authorized => :picking
      transition :under_review => :picking
    end

    event :delivering do
      transition :picking => :delivering, :if => :send_notification_order_shipped?
    end

    event :delivered do
      transition :delivering => :delivered, :if => :send_notification_order_delivered?
    end

    event :not_delivered do
      transition :delivering => :not_delivered
    end
  end

  def status
    STATUS[state]
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
    erp_payment.try(:payments) || 1
  end

  def delivery_time_for_a_shipped_order
    freight_delivery_time - WAREHOUSE_TIME
  end

  #FIX THIS IN MIGRATION WITH UPDATE_ALL
  # def credits
  #   credit = read_attribute :credits
  #   credit.nil? ? 0 : credit
  # end
  
  def user_name
    "#{user_first_name} #{user_last_name}".strip
  end

  def erp_payment
     payments.for_erp.last
  end
  
  private

  def initialize_order
    update_attributes(:number => (id * CONSTANT_FACTOR) + CONSTANT_NUMBER)
    self.update_attribute(:purchased_at, Time.now)
    Resque.enqueue(Abacos::InsertOrder, self.number)
    Resque.enqueue(Orders::NotificationOrderRequestedWorker, self.id)
  end
  
  def confirm_payment?
    #Seleciona a lista de estados de pagamento desta order
    payment_states = self.payments.map(&:state).uniq

    #so continua se so houver um tipo de estado listado e esse tipo de estado for authorized
    return false unless payment_states.include?("authorized") && payment_states.size == 1

    Resque.enqueue(Orders::NotificationPaymentConfirmedWorker, self.id)
    UserCredit.process!(self)
    
    Resque.enqueue_in(20.minutes, Abacos::ConfirmPayment, self.number)
    true
  end
  
  def cancel_order?
    Resque.enqueue(Orders::NotificationPaymentRefusedWorker, self.id)
    true
  end
  
  def refused_order?
    Resque.enqueue(Orders::NotificationPaymentRefusedWorker, self.id)
    true
  end

  def send_notification_order_delivered?
    Resque.enqueue(Orders::NotificationOrderDeliveredWorker, self.id)
    true
  end

  def send_notification_order_shipped?
    Resque.enqueue(Orders::NotificationOrderShippedWorker, self.id)
    true
  end
end
