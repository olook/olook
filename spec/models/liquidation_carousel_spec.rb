# == Schema Information
#
# Table name: liquidation_carousels
#
#  id             :integer          not null, primary key
#  liquidation_id :integer
#  image          :string(255)
#  order          :integer
#  created_at     :datetime
#  updated_at     :datetime
#  product_id     :integer
#

require 'spec_helper'

describe LiquidationCarousel do
  
  describe "validation" do
    it { should belong_to(:liquidation) }
  end

end

