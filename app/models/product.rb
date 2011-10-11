# -*- encoding : utf-8 -*-
class Product < ActiveRecord::Base
  Categories = {shoe: 1, bag: 2, jewel: 3}
  
  has_many :pictures
  
  validates :name, :presence => true
  validates :description, :presence => true
  
  scope :shoes , where(:category => Categories[:shoe])
  scope :bags  , where(:category => Categories[:bag])
  scope :jewels, where(:category => Categories[:jewel])
  
  def category
    Categories.key(read_attribute(:category)) || :none
  end

  def category=(value)
    write_attribute(:category, (Categories[value] || 0))
  end
end
