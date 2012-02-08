class LookbooksProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :lookbook
end
