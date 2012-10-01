class LineItem < ActiveRecord::Base
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
    # buscar amount_paid da order
    # order_amount_paid = self.order.amount_paid

    # buscar soma dos valores dos line_items
    line_item_sum = self.order.line_items.sum(&:retail_price)

    # calcular retail_price/line_item_sum para saber a porcentagem do produto na quantia paga.
    percentage = retail_price/line_item_sum
    
    # buscar crédito gerado pela order
    total_credit_amount = Credit.where(source: "loyalty_program_credit", order_id: self.order.id).sum(&:value)
    
    # devolver quantia através da porcentagem calculada anteriormente
    (total_credit_amount*percentage).round(2)
  end
end
