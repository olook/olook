# -*- encoding : utf-8 -*-
class Order < ActiveRecord::Base
  DEFAULT_QUANTITY = 1
  CONSTANT_NUMBER = 1782
  CONSTANT_FACTOR = 17

  STATUS = {
    "waiting_payment" => "Aguardando pagamento",
    "under_review" => "Em revisão",
    "canceled" => "Cancelado",
    "reversed" => "Estornado",
    "refunded" => "Reembolsado",
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
  has_one :payment, :dependent => :destroy
  has_one :freight, :dependent => :destroy
  has_many :order_state_transitions, :dependent => :destroy
  after_create :generate_number
  after_create :generate_identification_code

  scope :with_payment, joins(:payment)

  state_machine :initial => :in_the_cart do

    store_audit_trail

    after_transition :waiting_payment => :canceled, :do => :rollback_inventory
    after_transition :under_review => :reversed, :do => :rollback_inventory
    after_transition :under_review => :refunded, :do => :rollback_inventory

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
      transition :waiting_payment => :canceled
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
    items = line_items.select {|item| !item.variant.available_for_quantity? item.quantity}
    size_items = items.size
    items.each {|item| item.destroy}
    size_items
  end

  def add_variant(variant, quantity = Order::DEFAULT_QUANTITY)
    quantity = quantity.to_i
    if variant.available_for_quantity?(quantity)
      current_item = line_items.select { |item| item.variant == variant }.first
      if current_item
        current_item.update_attributes(:quantity => quantity)
      else
        current_item =  LineItem.new(:order_id => id, :variant_id => variant.id, :quantity => quantity, :price => variant.price)
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
    total + (freight_price || 0.0)
  end

  def line_items_total
    line_items.inject(0.0){|result, item| result + ((item.gift?) ? 0 : item.total_price)}
  end

  def credits
    result = read_attribute :credits
    result.nil? ? 0.0 : result
  end

  def total
    result = line_items_total
    if result > 0
      result = result - credits
    end
    result
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
        item.variant.decrement!(:inventory, item.quantity)
      end
    end
  end

  def increment_inventory_for_each_item
    ActiveRecord::Base.transaction do
      line_items.each do |item|
        item.variant.increment!(:inventory, item.quantity)
      end
    end
  end

  def rollback_inventory
    increment_inventory_for_each_item
  end

  def installments
    payment.try(:payments) || 1
  end

  private

  def generate_number
    new_number = (id * CONSTANT_FACTOR) + CONSTANT_NUMBER
    update_attributes(:number => new_number)
  end
end
