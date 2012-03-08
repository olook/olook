# -*- encoding : utf-8 -*-
class Credit < ActiveRecord::Base
  belongs_to :user
  belongs_to :order
  validates :value, :presence => true

  INVITE_BONUS = BigDecimal.new("10.00")

  def self.add_invite_bonus_for_invitee(invitee)
    if invitee.is_invited? && invitee.current_credit == 0
      invitee.credits.create!(:value => INVITE_BONUS, :total => INVITE_BONUS, :source => "invite_bonus")
    end
  end

  def self.add_invite_bonus_for_inviter(order)
  end

  def self.spend(amount, user, order)
    if user.current_credit >= amount
      remainder = user.current_credit - amount
      user.credits.create!(:value => amount, :total => remainder, :order => order, :source => "order")
    else
      false
    end
  end

end