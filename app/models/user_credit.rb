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
  
  def self.add_for_inviter(order)
    #CRIAR O CREDITO MGM PARA O INVITER
    #CRIAR O CREDITO DE FIDELIDADE
  end

end
