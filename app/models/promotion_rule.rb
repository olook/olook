# -*- encoding : utf-8 -*-


#
# There is an initializer "promotion_rules_initializer" that pre loads all the
# promotion_rules automatically (all rules that are in the /models/rules directory)
# just to create the rule in the database if needed. This way there is no need to
# mantain a list of possible rules, you only have to subclass this Class.
#
class PromotionRule < ActiveRecord::Base

  validates :name, :type, :presence => true

  has_many :rules_parameters
  has_many :promotions, :through => :rules_parameters

  def matches? user
    raise "You should call matches? on inherited classes"
  end

  def self.inherited(base)
    begin
    super base
    # register the inherited class (base) in the database if it is not there yet.
    # this is done in order to avoid manual insert into database whenever we create a
    # new promotion_rule
    Rails.logger.info "inserting a new PromotionRule #{base.name} into database"
    where(:type => base.name).first_or_create({:name => base.name})
    rescue
    end
  end

end
