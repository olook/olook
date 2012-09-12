require 'spec_helper'

describe PromotionPayment do

  it { should belong_to(:promotion) }
  it { should validate_presence_of(:promotion_id) }
  it { should validate_presence_of(:discount_percent) }
  
end
