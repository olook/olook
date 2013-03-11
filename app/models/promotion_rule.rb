# -*- encoding : utf-8 -*-


#
# There is an initializer "promotion_rules_initializer" that pre loads all the
# promotion_rules automatically (all rules that are in the /models/rules directory)
# just to create the rule in the database if needed. This way there is no need to
# mantain a list of possible rules, you only have to subclass this Class.
#
class PromotionRule < ActiveRecord::Base

  validates :type, :presence => true

  has_many :rule_parameters
  has_many :promotions, :through => :rule_parameters

  protected
    # This method should be overrided on subclasses
    def matches? cart, parameter; end
end
