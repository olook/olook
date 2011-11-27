# -*- encoding : utf-8 -*-
module InviteBonus
  def self.calculate(member)
    bonus = for_accepted_invites(member) + for_being_invited(member) - already_used(member)
    bonus = 300.0 if bonus > 300.0
    bonus
  end

  def self.already_used(member)
    member.orders.inject(0) {|result, item| result + (item.credits || 0)}
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
