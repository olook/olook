class LiquidationProduct < ActiveRecord::Base
  belongs_to :liquidation
  belongs_to :product
end
