class PromotionAction < ActiveRecord::Base
  validates :type, presence: true
  has_many :action_parameters
  has_many :promotions, through: :action_parameters


  def self.inherited(base)
    begin
    super base
    # register the inherited class (base) in the database if it is not there yet.
    # this is done in order to avoid manual insert into database whenever we create a
    # new promotion_rule
    Rails.logger.info "inserting a new PromotionAction #{base.name} into database"
    where(:type => base.name).first_or_create({:name => base.name})
    rescue
    end
  end

  def apply(cart, param)
    raise "You should call matches? on inherited classes"
  end

  def calculate(cart, param)
    raise "You should call matches? on inherited classes"
  end
end
