class UsedPromotion < ActiveRecord::Base
  belongs_to :order
  belongs_to :promotion
end
