# -*- encoding : utf-8 -*-
class Credit < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  validates :value, :presence => true

  INVITE_BONUS = BigDecimal.new("10.00")

  # TO DO: Refactor this class and move these methods to CreditService class

  def self.add_for_invitee(invitee)
    if invitee.is_invited? && invitee.current_credit == 0
      invitee.credits.create!(:value => INVITE_BONUS, :total => INVITE_BONUS, :source => "inviter_bonus")
    end
  end

  def self.add_for_inviter(buyer, order)
    # TO DO: Double check to see if the credit was already gave for this orer
    inviter = buyer.try(:inviter)
    if inviter && buyer.first_buy?
      updated_total = inviter.current_credit + INVITE_BONUS
      inviter.credits.create!(:value => INVITE_BONUS, :total => updated_total, :order => order, :source => "invitee_bonus")
    end
  end

  def self.remove(amount, user, order)
    if user.current_credit >= amount
      updated_total = user.current_credit - amount
      user.credits.create!(:value => amount, :total => updated_total, :order => order, :source => "order")
    else
      false
    end
  end

  def self.add(amount, user, order)
    # TO DO: Check if value exceeds maximum amount of credit a user can have (300)
    updated_total = user.current_credit + amount
    user.credits.create!(:value => amount, :total => updated_total, :order => order, :source => "order")
  end

end