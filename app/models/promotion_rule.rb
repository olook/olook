# -*- encoding : utf-8 -*-


#
# There is an initializer "promotion_rules_initializer" that pre loads all the
# promotion_rules automatically (all rules that are in the /models/rules directory)
# just to create the rule in the database if needed. This way there is no need to
# mantain a list of possible rules, you only have to subclass this Class.
#
class PromotionRule < ActiveRecord::Base

  validates :type, :name, :presence => true

  has_many :rule_parameters
  has_many :promotions, :through => :rule_parameters

  def matches? cart, parameter
    raise "You should call matches? on inherited classes"
  end

  def self.inherited(base)
    super base
    begin
      # register the inherited class (base) in the database if it is not there yet.
      # this is done in order to avoid manual insert into database whenever we create a
      # new promotion_rule
      Rails.logger.info "inserting a new PromotionRule #{base.type} into database"
      where(:type => base.name).first_or_create({:type => base.name})
    rescue Exception => e
      Rails.logger.error e
    end
  end
end
