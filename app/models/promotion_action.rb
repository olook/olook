class PromotionAction < ActiveRecord::Base
  # include Parameters

  validates :type, presence: true
  has_many :action_parameters
  has_many :promotions, through: :action_parameters

# def params= value
#   promotion.action_parameter.action_params = value
# end

  def self.inherited(base)
    begin
    super base
    # register the inherited class (base) in the database if it is not there yet.
    # this is done in order to avoid manual insert into database whenever we create a
    # new promotion_rule
    Rails.logger.info "inserting a new PromotionAction #{base.name} into database"
    where(:type => base.name).first_or_create({:type => base.name})
    rescue
    end
  end

  def apply(cart, param)
    raise "You should call matches? on inherited classes"
  end

  def calculate(cart, param)
    raise "You should call matches? on inherited classes"
  end

  def is_greater_than_coupon?(cart)
    total_discount_for(cart) > cart.coupon.value
  end
end
