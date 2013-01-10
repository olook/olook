class PromotionAction < ActiveRecord::Base
  include Parameters

  has_many :action_parameters
  has_many :promotions, through: :action_parameters

  def params
    promotion.action_parameter.param
  end

  def params= value
    promotion.action_parameter.param = value
  end

end
