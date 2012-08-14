class InviteCreditType < CreditType

  def remove(amount, user_credit, order)
    if user_credit.total >= amount
      updated_total = user_credit.total - amount
      user_credit.credits.create!(:user => user_credit.user, :value => amount, :total => updated_total, :order => order, :source => "order_debit", 
      :reason => "Order #{order.number} received", :is_debit => true)
    else
      false
    end
  end

  def add(amount, user_credit, order)
    updated_total = user_credit.total + amount
    user_credit.credits.create!(:user => user_credit.user, :value => amount, :total => updated_total, :order => order, :source => "order_credit",
    :reason => "Order #{order.number} canceled")
  end

end
