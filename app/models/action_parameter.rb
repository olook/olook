class ActionParameter < ActiveRecord::Base
  belongs_to :promotion
  belongs_to :promotion_action
end
