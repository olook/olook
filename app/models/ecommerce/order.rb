# -*- encoding : utf-8 -*-
class Order < ActiveRecord::Base
  DEFAULT_QUANTITY = 1
  CONSTANT_NUMBER = 1782
  CONSTANT_FACTOR = 17

  belongs_to :user
  has_many :variants, :through => :line_items
  has_many :line_items, :dependent => :destroy
  delegate :name, :to => :user, :prefix => true
  delegate :email, :to => :user, :prefix => true
  delegate :price, :to => :freight, :prefix => true
  has_one :payment
  has_one :freight
  after_create :generate_number
  after_create :generate_identification_code

  state_machine :initial => :waiting_payment do
    event :under_analysis do
      transition :waiting_payment => :waiting_payment
    end

    event :authorized do
      transition :waiting_payment => :waiting_payment
    end

    event :billet_printed do
      transition :waiting_payment => :waiting_payment
    end

    event :started do
      transition :started => :waiting_payment
    end

    event :under_analysis do
      transition :waiting_payment => :waiting_payment
    end

    event :completed do
      transition :waiting_payment => :completed
    end

    event :completed do
      transition :under_review => :completed
    end

    event :under_review do
      transition :waiting_payment => :under_review
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
  end

  def add_variant(variant, quantity = Order::DEFAULT_QUANTITY)
    if variant.available?
      current_item = line_items.select { |item| item.variant == variant }.first
      if current_item
        current_item.increment!(:quantity, quantity)
      else
        current_item =  LineItem.new(:order_id => id, :variant_id => variant.id, :quantity => quantity)
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
    total + freight.price
  end

  def total
    total = line_items.inject(0){|result, item| result + item.total_price }
    total = total - credits if credits
    total
  end

  private

  def generate_identification_code
    code = SecureRandom.hex(32)
    while Order.find_by_identification_code(code)
      code = SecureRandom.hex(32)
    end
    update_attributes(:identification_code => code)
  end

  def generate_number
    new_number = (id * CONSTANT_FACTOR) + CONSTANT_NUMBER
    update_attributes(:number => new_number)
  end
end
