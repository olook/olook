class Look < ActiveRecord::Base
  attr_accessible :launched_at, :picture
  belongs_to :product
  belongs_to :profile

  def self.build_and_create(attr)
    look = self.new
    look.product_id = attr[:product_id]
    look.picture = attr[:picture]
    look.launched_at = attr[:launched_at]
    look.profile_id = attr[:profile_id]
    look.save
    look
  end
end
