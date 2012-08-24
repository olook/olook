class UserCredit < ActiveRecord::Base
  belongs_to :credit_type
  belongs_to :user
  has_many :credits
  
  INVITE_BONUS = BigDecimal.new("10.00")
  TRANSACTION_LIMIT = 150.0
  CREDIT_CODES = {invite: 'MGM', loyalty_program: 'Fidelidade', redeem: 'Reembolso'}

  def total(date = DateTime.now)
    credit_type.total(self, date)
  end

  def add(opts)
    raise ArgumentError.new('User is required!') unless opts[:user].is_a?(User)
    raise ArgumentError.new('Amount is required!') if opts[:amount].nil?
    
    amount = BigDecimal.new(opts.delete(:amount).to_s)

    opts.merge!({
      :total => (total + amount),
      :user_credit => self,
      :value => amount
    })

    credit_type.add(opts)
  end

  #Set total in the remotion.
  def remove(opts)
    raise ArgumentError.new('User is required!') unless opts[:user].is_a?(User)
    raise ArgumentError.new('Amount is required!') if opts[:amount].nil?
    
    amount = BigDecimal.new(opts.delete(:amount).to_s)

    opts.merge!({
      :user_credit => self,
      :total => (total - amount),
      :value => amount
    })

    credit_type.remove(opts)
  end
  
  def self.process!(order)
    # TO DO: Double check to see if the credit was already given for this order

    # creates MGM credits for inviter
    UserCredit.add_invite_credits(order) if Setting.invite_credits_available
    # creates loyalty program credits
    UserCredit.add_loyalty_program_credits(order) if Setting.loyalty_program_credits_available
  end

  private
    def self.add_invite_credits(order)      
      buyer, inviter = order.user, buyer.try(:inviter)
      
      if inviter && buyer.first_buy?
        inviter.user_credits_for(:invite).add(INVITE_BONUS, order) 
      end
    end

    def self.add_loyalty_program_credits(order)
      user_credit = order.user.user_credits_for(:loyalty_program)
      amount = order.amount_paid * LoyaltyProgramCreditType::PERCENTAGE_ON_ORDER
     
      user_credit.add({
        :user => user,
        :order => order,
        :amount => amount
      })
    end
end
