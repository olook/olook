# == Schema Information
#
# Table name: lookbooks_products
#
#  id          :integer          not null, primary key
#  lookbook_id :integer
#  product_id  :integer
#  criteo      :boolean          default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

class LookbooksProduct < ActiveRecord::Base
  belongs_to :product
  belongs_to :lookbook
end
