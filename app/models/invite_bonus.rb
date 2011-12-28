# -*- encoding : utf-8 -*-
module InviteBonus
  LIMIT_FOR_EACH_USER = 300.0

  def self.calculate(member, current_order = nil)
    bonus = for_accepted_invites(member) + for_being_invited(member)
    bonus = LIMIT_FOR_EACH_USER if bonus > LIMIT_FOR_EACH_USER
    bonus -= already_used(member, current_order)
    bonus
  end

  def self.already_used(member, current_order = nil)
    count = 0
    member.orders.each do |item|
      available_for_count_credits = (!item.canceled? && !item.refunded? && !item.reversed? && !item.payment.nil?)
      if available_for_count_credits
        credits = item.credits || 0
        count = count + credits
      else
        if current_order
          if item.id == current_order.id
            credits = item.credits || 0
            count = count + credits
          end
        end
      end
    end
    count.to_f
  end

protected
  module FirstPromotion
    END_DATE = DateTime.civil(2011, 11, 9, 10, 0, 0)

    def self.for_accepted_invites(member)
      accepted_invites_count = member.invites.accepted.where('accepted_at <= :end_date', :end_date => END_DATE).count
      accepted_invites_count * 10.0
    end
  end

  module SecondPromotion
    START_DATE = FirstPromotion::END_DATE

    def self.for_accepted_invites(member)
      accepted_invites_count = member.invites.accepted.where('accepted_at > :start_date', :start_date => START_DATE).count
      (accepted_invites_count / 5) * 20.0
    end
  end

  @promotion_rules = [FirstPromotion, SecondPromotion]

  def self.for_accepted_invites(member)
    @promotion_rules.inject(0) do |total, promotion_rule|
      total + promotion_rule.for_accepted_invites(member)
    end
  end

  def self.for_being_invited(member)
    member.is_invited? ? 10.0 : 0.0
  end
end
