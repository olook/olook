class RulesParameter < ActiveRecord::Base
  include Parameters

  belongs_to :promotion
  belongs_to :promotion_rule

end
