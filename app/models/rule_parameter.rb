class RuleParameter < ActiveRecord::Base

  belongs_to :matchable, polymorphic: true
  belongs_to :promotion_rule

  def matches? cart
    promotion_rule.matches?(cart, rules_params)
  end

end
