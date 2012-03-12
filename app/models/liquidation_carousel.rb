class LiquidationCarousel < ActiveRecord::Base
	  belongs_to :liquidation

		mount_uploader :image, ImageUploader

end
