class UserCredit < ActiveRecord::Base
  belongs_to :credit_type
  belongs_to :user
  has_many :credits
  INVITE_BONUS = BigDecimal.new("10.00")
  
  def total(date = DateTime.now)
    credit_type.total(self, date)
  end

  def add(amount, order)
  	self.credit_type.add(amount, self, order)
  end

  def remove(amount,order)
    self.credit_type.remove(amount, self, order)
  end
  
  def self.process!(order)
    # TO DO: Double check to see if the credit was already given for this order

    # creates MGM credits for inviter
    UserCredit.add_invite_credits(order)
    # creates loyalty program credits
    UserCredit.add_loyalty_program_credits(order)
  end

  private
    def self.add_invite_credits(order)
      buyer = order.user
      inviter = buyer.try(:inviter)
      inviter.user_credits_for(:invite).add(INVITE_BONUS, order) if inviter && buyer.first_buy?
    end

    def self.add_loyalty_program_credits(order)
      user_credit = order.user.user_credits_for(:loyalty_program)
      amount = order.amount_paid*0.20
      user_credit.add(amount, order)
    end

end
