# encoding: utf-8
class InviteCreditType < CreditType
  def self.amount_of_inviter_bonus_credits(user_credit)
    amount_credits_for(user_credit,0,:invitee_bonus) - amount_credits_for(user_credit,1,:invitee_bonus)
  end

  def self.amount_of_invitee_bonus_credits(user_credit)
    amount_credits_for(user_credit,0,:inviter_bonus) - amount_credits_for(user_credit,1,:inviter_bonus)
  end

  def self.quantity_of_inviter_bonus_credits(user_credit)
    credits_for(user_credit,0,:invitee_bonus).count
  end

  private
  def self.amount_credits_for(user_credit, is_debit, source)
    credits_for(user_credit, is_debit, source).sum(:value)
  end

  def self.credits_for(user_credit, is_debit, source)
    user_credit.credits.where(source: source, is_debit: is_debit)
  end
end