class ActionParameter < ActiveRecord::Base
  include Parameters

  belongs_to :matchable, polymorphic: true
  belongs_to :promotion_action
end
