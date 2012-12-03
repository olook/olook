# == Schema Information
#
# Table name: lookbook_image_maps
#
#  id          :integer          not null, primary key
#  lookbook_id :integer
#  image_id    :integer
#  product_id  :integer
#  coord_x     :integer
#  coord_y     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class LookbookImageMap < ActiveRecord::Base
  belongs_to :lookbook
  belongs_to :image
  belongs_to :product

  validates :product, presence: true, associated: true
  validates :image, presence: true, associated: true
  validates :lookbook, presence: true, associated: true

  attr_accessor :product_name
end
