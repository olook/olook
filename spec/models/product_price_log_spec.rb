require 'spec_helper'

describe ProductPriceLog do
    it { should belong_to(:product) }
    it { should validate_presence_of(:product_id) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:retail_price) }
end
