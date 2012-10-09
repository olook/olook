class LineItem < ActiveRecord::Base
  has_many :debits, :class_name => "Credit", :foreign_key => "line_item_id"
  belongs_to :variant
  belongs_to :order
  validates_presence_of :variant_id
  validates_presence_of :order_id
  validates_presence_of :quantity
  scope :ordered_by_price, order('line_items.price DESC')
  delegate :liquidation?, :to => :variant
  
  def retail_price
    retail = read_attribute(:retail_price)
    retail ||= price
    retail
  end

  def total_price
    retail_price * quantity
  end

  def calculate_loyalty_credit_amount
    # buscar soma dos valores dos line_items
    line_item_sum = self.order.line_items.sum(&:retail_price)

    # calcular retail_price/line_item_sum para saber a porcentagem do produto na quantia paga.
    percentage = retail_price/line_item_sum
    
    # buscar crédito gerado pela order
    total_credit_amount = find_original_loyalty_credit.try(:value)
    
    total_credit_amount ||= 0

    # devolver quantia através da porcentagem calculada anteriormente
    (total_credit_amount*percentage).round(2)
  end

  def calculate_debit_amount
    (debits.sum(:value)).round(2)
  end

  def calculate_available_credits
    calculate_loyalty_credit_amount - calculate_debit_amount
  end

  def remove_loyalty_credits
    available_credits = calculate_available_credits
    amount_to_remove = available_credits
    original_credit = find_original_loyalty_credit
    if original_credit
      if (amount_to_remove >= original_credit.amount_available?)
        amount_to_remove = original_credit.amount_available?
      end
      debits << create_debit(original_credit, amount_to_remove)
      amount_to_remove = available_credits - amount_to_remove
    end
  end

  private

  def find_original_loyalty_credit
    Credit.where(source: "loyalty_program_credit", order_id: self.order.id, is_debit: false).first
  end

  def create_debit(credit, amount)
    user = order.user
    user_credit = user.user_credits_for(:loyalty_program)
    credit.debits.create!({
        :source => "loyalty_program_debit",
        :is_debit => true,
        :value => amount,
        :expires_at => credit.expires_at,
        :activates_at => credit.activates_at,
        :user_id => user.id,
        :order_id => order.id,
        :user_credit_id => user_credit.id,
        :line_item_id => id
      })
  end
end