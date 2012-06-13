class LookbookImageMap < ActiveRecord::Base
  belongs_to :lookbook
  belongs_to :image
  belongs_to :product
end
