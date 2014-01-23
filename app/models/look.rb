class Look < ActiveRecord::Base
  attr_accessible :launched_at, :picture
  belongs_to :product
  belongs_to :profile

  mount_uploader :full_look_picture, LookImageUploader
  mount_uploader :front_picture, LookImageUploader

  def self.build_and_create(attr)
    look = self.new
    look.product_id = attr[:product_id]
    look.remote_full_look_picture_url = attr[:full_look_picture]
    look.remote_front_picture_url = attr[:front_picture]
    look.launched_at = attr[:launched_at]
    look.profile_id = attr[:profile_id]
    look.save
    look
  end
end
