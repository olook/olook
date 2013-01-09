class ActionParameter < ActiveRecord::Base
  include Parameters
  
  belongs_to :promotion
  belongs_to :promotion_action
end
