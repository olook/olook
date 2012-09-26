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
  has_many :moip_callbacks
  has_many :line_items, :dependent => :destroy
  
  after_create :initialize_order

  delegate :price, :to => :freight, :prefix => true, :allow_nil => true
  delegate :city, :to => :freight, :prefix => true, :allow_nil => true
  delegate :state, :to => :freight, :prefix => true, :allow_nil => true
  delegate :delivery_time, :to => :freight, :prefix => true, :allow_nil => true

  def self.with_payment
    joins(:payments).uniq
  end

  def self.purchased
    where("orders.state NOT IN ('canceled', 'reversed', 'refunded')")
  end

  def self.paid
     where("orders.state IN ('under_review', 'picking', 'delivering', 'delivered', 'authorized')")
  end

  def self.payments_with_discount(percent=0)
    paid
    .select("orders.*, sum(p.percent) as amount_of_percent")
    .joins('join payments p on p.order_id = orders.id and p.type in ("CreditPayment","CouponPayment", "OlookletPayment", "GiftPayment","PromotionPayment")')
    .group("orders.id")
    .having("amount_of_percent >= #{percent}")
    .uniq
  end

  def self.with_complete_payment
    joins(:payments).uniq.where("payments.state IN ('authorized','completed')")
  end

  state_machine :initial => :waiting_payment do
    store_audit_trail

    state :delivered
    state :delivering
    state :not_delivered
    state :picking
    state :waiting_payment
    state :authorized
    state :under_review 

    after_transition any => :authorized, :do => :transition_to_authorized
    
    state :reversed do
      after_save do |order|
        order.payments.where(Payment.arel_table[:state].not_eq('reversed')).each do |payment|
          events_for_payment = payment.state_events(guard: false)
          if events_for_payment.include?(:cancel)
            payment.cancel
          elsif events_for_payment.include?(:reverse)
            payment.reverse
          end
        end
      end
    end
    
    state :refunded do
      after_save do |order|
        order.payments.where(Payment.arel_table[:state].not_eq('refunded')).each do |payment|
          events_for_payment = payment.state_events(guard: false)
          if events_for_payment.include?(:cancel)
            payment.cancel
          elsif events_for_payment.include?(:refund)
            payment.refund
          end
        end
      end
    end
    
    
    state :canceled do
      after_save do |order|
        order.payments.where(Payment.arel_table[:state].not_eq('cancelled')).each do |payment|
          events_for_payment = payment.state_events(guard: false)
          if events_for_payment.include?(:cancel)
            payment.cancel
          elsif events_for_payment.include?(:refund)
            payment.refund
          end
        end
      end
    end

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
      transition :authorized => :reversed, :if => :refused_order?
      transition :under_review => :reversed, :if => :refused_order?
      transition :picking => :reversed, :if => :refused_order?
      transition :delivering => :reversed, :if => :refused_order?
      transition :not_delivered => :reversed, :if => :refused_order?
      transition :delivered => :reversed, :if => :refused_order?
    end

    event :refunded do
      transition :authorized => :refunded, :if => :refused_order?
      transition :under_review => :refunded, :if => :refused_order?
      transition :picking => :refunded, :if => :refused_order?
      transition :delivering => :refunded, :if => :refused_order?
      transition :not_delivered => :refunded, :if => :refused_order?
      transition :delivered=> :refunded, :if => :refused_order?
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

  def user_name
    "#{user_first_name} #{user_last_name}".strip
  end

  def erp_payment
     payments.for_erp.last
  end

  def loyalty_payment
    payments.for_loyalty.last
  end

  def redeem_payment
    payments.for_redeem.last
  end

  def payment_rollback?
    self.refunded? || self.canceled? || self.reversed?
  end
  
  def transition_to_authorized
    Resque.enqueue_in(1.minute, Orders::NotificationPaymentConfirmedWorker, self.id)
    UserCredit.process!(self)

    Resque.enqueue_in(20.minutes, Abacos::ConfirmPayment, self.number)
  end
  
  
  private

  def initialize_order
    update_attributes(:number => (id * CONSTANT_FACTOR) + CONSTANT_NUMBER)
    self.update_attribute(:purchased_at, Time.now)
    Resque.enqueue_in(1.minute, Abacos::InsertOrder, self.number)
    Resque.enqueue_in(1.minute, Orders::NotificationOrderRequestedWorker, self.id)
    Resque.enqueue_in(1.minute, SAC::AlertWorker, :order, self.number)
  end
  
  def confirm_payment?
    #Seleciona a lista de estados de pagamento desta order
    payment_states = self.payments.map(&:state).uniq

    #so continua se so houver um tipo de estado listado e esse tipo de estado for authorized
    return false unless payment_states.include?("authorized") && payment_states.size == 1
    true
  end
  
  def cancel_order?
    Resque.enqueue_in(1.minute, Orders::NotificationPaymentRefusedWorker, self.id)
    true
  end
  
  def refused_order?
    Resque.enqueue_in(1.minute, Orders::NotificationPaymentRefusedWorker, self.id)
    true
  end

  def send_notification_order_delivered?
    Resque.enqueue_in(1.minute, Orders::NotificationOrderDeliveredWorker, self.id)
    true
  end

  def send_notification_order_shipped?
    Resque.enqueue_in(1.minute, Orders::NotificationOrderShippedWorker, self.id)
    true
  end
end
