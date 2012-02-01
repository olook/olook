class Promotion < ActiveRecord::Base
  validates_presence_of :name, :discount_percent
  #serialize :params, Hash
  scope :active, where(:active => true)

  def apply_strategy user=nil
    klass = "Promotions::#{self.strategy.to_s.camelize}".constantize
    klass.new(self.param, user).process
  end
end
