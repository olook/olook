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

  def markdown
    if sale_price == 0
      0
    else
      price - sale_price
    end
  end

  def total_discounts
    (order.markdown_discount + order.coupon_discount + order.loyalty_credits_discount + order.other_credits_discount) * percentage
  end

  def calculate_loyalty_credit_amount
    return 0 if is_freebie
    
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
    return 0 if is_freebie
    calculate_loyalty_credit_amount - calculate_debit_amount
  end

  def remove_loyalty_credits
    total_amount = calculate_available_credits
    original_credit = find_original_loyalty_credit
    if original_credit
      total_amount -= create_debit(original_credit, total_amount)
    end

    if total_amount > 0
      find_credits_to_expire.each do |credit|
        total_amount -= create_debit(credit, total_amount)
        if (total_amount <= 0)
          break
        end
      end
    end
    debits
  end

  def calculate_markdown_discount
    (order.markdown_discount*percentage).round(2)
  end

  def calculate_coupon_discount
    (order.coupon_discount*percentage).round(2)
  end  

  def calculate_loyalty_credits_discount
    (order.loyalty_credits_discount*percentage).round(2)
  end  

  def calculate_redeem_credits_discount
    (order.redeem_credits_discount*percentage).round(2)
  end  

  def calculate_invite_credits_discount
    (order.invite_credits_discount*percentage).round(2)
  end  

  def calculate_other_credits_discount
    (order.other_credits_discount*percentage).round(2)
  end  

  def total_paid
    retail_price
  end

  private

    def line_item_sum
      @line_item_sum ||= self.order.line_items.inject(0) do | sum, line_item | 
        sum += (line_item.is_freebie ? 0 : line_item.retail_price)
      end
    end

    def find_original_loyalty_credit
      Credit.where(source: "loyalty_program_credit", order_id: self.order.id, is_debit: false).first
    end

    def find_credits_to_expire
      Credit.loyalty_credits_to_expire.joins(" JOIN orders o on credits.order_id = o.id").where("o.user_id = ?", order.user_id).order(:expires_at)
    end

    def create_debit(credit, total_amount)
      amount_to_remove = total_amount
      if (amount_to_remove >= credit.amount_available?)
        amount_to_remove = credit.amount_available?
      end
      if (amount_to_remove > 0)
        user = order.user
        user_credit = user.user_credits_for(:loyalty_program)
        debits << credit.debits.create!({
            :source => "loyalty_program_refund_debit",
            :is_debit => true,
            :value => amount_to_remove,
            :expires_at => credit.expires_at,
            :activates_at => credit.activates_at,
            :user_id => user.id,
            :order_id => order.id,
            :user_credit_id => user_credit.id,
            :line_item_id => id
          })
      end
      amount_to_remove
    end

    def percentage
      # calcular retail_price/line_item_sum para saber a porcentagem do produto na quantia paga.
      retail_price/line_item_sum
    end
end
