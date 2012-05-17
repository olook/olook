# -*- encoding : utf-8 -*-
# TO DO: Model should be named CreditTransaction
class Credit < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  validates :value, :presence => true

  LIMIT_FOR_EACH_USER = BigDecimal.new("300.00")

  INVITE_BONUS = BigDecimal.new("10.00")

  # TO DO: Refactor this class and move these methods to CreditService class

  def self.add_for_invitee(invitee)
    if invitee.is_invited? && invitee.current_credit == 0
      invitee.credits.create!(:value => INVITE_BONUS, :total => INVITE_BONUS, :source => "inviter_bonus", :reason => "Accepted invite from #{invitee.inviter.name}")
    end
  end

  def self.add_for_inviter(buyer, order)
    # TO DO: Double check to see if the credit was already gave for this order
    inviter = buyer.try(:inviter)
    if inviter && buyer.first_buy? && inviter.has_not_exceeded_credit_limit?(INVITE_BONUS)
      updated_total = inviter.current_credit + INVITE_BONUS
      inviter.credits.create!(:value => INVITE_BONUS, :total => updated_total, :order => order, :source => "invitee_bonus", :reason => "#{buyer.name} first buy")
    else
      false
    end
  end

  def self.remove(amount, user, order)
    if user.current_credit >= amount
      updated_total = user.current_credit - amount
      user.credits.create!(:value => amount, :total => updated_total, :order => order, :source => "order_debit", 
      :reason => "Order #{order.number} received", :is_debit => true)
    else
      false
    end
  end

  def self.add(amount, user, order)
    if user.has_not_exceeded_credit_limit?(INVITE_BONUS)
      updated_total = user.current_credit + amount
      user.credits.create!(:value => amount, :total => updated_total, :order => order, :source => "order_credit",
      :reason => "Order #{order.number} canceled")
    end
  end

end