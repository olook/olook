class Liquidation < ActiveRecord::Base
  has_many :liquidation_products
  #validates_presence_of :name, :description
  #validates_length_of :description, :maximum => 100
end
