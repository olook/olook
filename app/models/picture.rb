# -*- encoding : utf-8 -*-
class Picture < ActiveRecord::Base
  DisplayOn = {gallery: 1, member_banner: 2, visitor_banner: 3}

  belongs_to :product
  
  validates :image, :presence => true
  validates :display_on, :presence => true
  validates :product, :presence => true

  def display_on
    DisplayOn.key(read_attribute(:display_on)) || :none
  end

  def display_on=(value)
    write_attribute(:display_on, (DisplayOn[value] || 0))
  end
end
