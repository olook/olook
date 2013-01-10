class Promotion < ActiveRecord::Base
  validates_presence_of :name, :banner_label

  scope :active, where(:active => true)
  scope :active_and_not_expired, lambda {|date| active.where('starts_at <= :date AND ends_at >= :date', date: date)}

  has_many :promotion_payments

  has_many :rule_parameters
  has_many :promotion_rules, :through => :rule_parameters

  has_one :action_parameter
  has_one :promotion_action, through: :action_parameter

  accepts_nested_attributes_for :rule_parameters, :action_parameter

  def apply cart
    promotion_action.apply cart, self
  end

end
