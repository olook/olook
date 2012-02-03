class Promotion < ActiveRecord::Base
  validates_presence_of :name, :discount_percent, :priority
  validates_uniqueness_of :name, :priority

  scope :active, where(:active => true)

  def load_strategy
    "Promotions::#{self.strategy.to_s.camelize}".constantize
  end
end
