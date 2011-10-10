class Product < ActiveRecord::Base
  Categories = {shoe: 1, bag: 2, jewel: 3}
  
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
