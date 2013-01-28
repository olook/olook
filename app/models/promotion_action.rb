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
    cart.update_attributes(coupon_code: nil) if cart.coupon
    calculate(cart.items, param).each do |item|
      adjustment = item[:adjustment]
      item = cart.items.find(item[:id])
      item.cart_item_adjustment.update_attributes(value: adjustment)
    end
  end

  def simulate(cart, param)
    cart.items.any? ? calculate(cart.items, param).map{|item| item[:adjustment]}.reduce(:+) : 0
  end

  protected  
    
    #
    # This method should return an Array of Hashes in the form:
    # => [{id: item.id, adjustment: item.price}]
    #
    def calculate(cart, param)
      raise "You should call matches? on inherited classes"
    end
end
