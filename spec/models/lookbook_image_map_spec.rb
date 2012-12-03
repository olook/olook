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

require 'spec_helper'

describe LookbookImageMap do
  it { should belong_to(:lookbook) }
  it { should belong_to(:image) }
  it { should belong_to(:product) }
  it { should validate_presence_of(:product) }
  it { should validate_presence_of(:image) }
  it { should validate_presence_of(:product) }
  
end
