class LookbookImageMap < ActiveRecord::Base
  belongs_to :lookbook
  belongs_to :image
  belongs_to :product

  validates :product, presence: true, associated: true
  validates :image, presence: true, associated: true
  validates :lookbook, presence: true, associated: true

  attr_accessor :product_name
end
