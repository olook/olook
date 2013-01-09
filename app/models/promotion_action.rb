class PromotionAction < ActiveRecord::Base
  has_many :action_parameters
  has_many :promotions, through: :action_parameters

end
